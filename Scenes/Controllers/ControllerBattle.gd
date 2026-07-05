extends Controller


signal target_selected
signal player_action_finalized	# Emitted once player has all necessary choices (action, possibly blueprint, possibly target) to select party member action

const MIN_ACCURACY: int = 1
const MAX_ACCURACY: int = 99
const MIN_CRIT: int = 1
const MAX_CRIT: int = 99

var current_actor
var selected_action: Combatant.ACTION
var selected_blueprint
var selected_target

var party_ran: bool = false		# Party running results in immediate combat loss. Avoids softlocks

func _ready() -> void:
	initializeTestFight()
	mainLoop()


func mainLoop():

	while true:
		selected_action = Combatant.ACTION.NULL
		selected_blueprint = null
		selected_target = null
		current_actor = getNextActor()
		current_actor.beginTurn()

		if isBattleOver():	# Character may have died from poison, so check here
			break
		else:
			updateCombatantStatusDisplays()
			pushCombatantBattleMessages(current_actor)
			if current_actor is PartyCombatant:
				await showBattleMessages()

		$PartyStatusDisplay.toggleTurnIndicators(current_actor)

		await chooseAction(current_actor)
		await displayAndRunChosenAction(current_actor, selected_action, selected_blueprint, selected_target)

		$PartyStatusDisplay.toggleTurnIndicators(current_actor)

		current_actor.endTurn()
		if not isBattleOver():
			pushCombatantBattleMessages(current_actor)
		updateCombatantStatusDisplays()
		await showBattleMessages()

		# Check if battle is over after each action
		if isBattleOver():	# Character may have died from poison
			switchToPlayAgainMode()
			break

	# Battle end routine
	if isPartyDefeated():
		battleLost()
	elif allEnemiesDefeated():
		battleWon()


# Run this if player lost battle
func battleLost() -> void:
	$BattleMessageDisplay.pushBattleMessage("You lose! All party members have been given " + str(consolationMuta()) + " Muta. Build them up and try again!")
	ActiveSaveData.awardMuta(consolationMuta())
	await showBattleMessages(true)


# Run this if player won battle
func battleWon() -> void:
	$BattleMessageDisplay.pushBattleMessage("You win!\nReceived " + str(victoryMuta()) + " Muta. Build your party up for the next battle!")
	ActiveSaveData.awardMuta(victoryMuta())
	ActiveSaveData.current_battle += 1
	await showBattleMessages(true)


# Current actor chooses action; parameters assigned for execution
func chooseAction(current_actor) -> void:
	if current_actor is PartyCombatant:
		$BattleActionMenu.enableUseableButtons(current_actor)
		await player_action_finalized
		disablePlayerControls()
	else:
		selected_action = current_actor.chooseAction()
		if selected_action == Combatant.ACTION.BLUEPRINT:
			selected_blueprint = current_actor.chooseBlueprint()
			if not selected_blueprint.multitarget:
				selected_target = current_actor.chooseTarget(selected_blueprint, getTargetList(current_actor, selected_blueprint))


# Not all actions will have assigned blueprints or targets
# 	e.g. multitarget attacks have no assigned target, wait/run has no blueprint
func displayAndRunChosenAction(actor, action: Combatant.ACTION, blueprint = null, target = null):
	if action == Combatant.ACTION.WAIT:
		actor.wait()
		pushCombatantBattleMessages(actor)
	elif action == Combatant.ACTION.RUN:
		actor.run()
		party_ran = true
		pushCombatantBattleMessages(actor)
	elif action == Combatant.ACTION.BLUEPRINT:
		if blueprint.multitarget:
			executeMultitargetBlueprint(actor, blueprint, getTargetList(actor, blueprint))
		else:
			executeBlueprint(actor, blueprint, target)
	else:
		push_error("Unprocessed action: " + str(action))


func getTargetList(combatant: Combatant, blueprint: Blueprint) -> Array:
	if blueprint is BlueprintAttack:
		if combatant is PartyCombatant:
			return activeCombatantsInGroup($EnemyDisplayGrid.getEnemyCombatants())
		else:
			return activeCombatantsInGroup($PartyStatusDisplay.getPlayerCombatants())
	elif blueprint is BlueprintSupport:
		if blueprint.self_target_only:
			return [combatant]
		elif combatant is PartyCombatant:
			if blueprint.can_revive:
				return $PartyStatusDisplay.getPlayerCombatants()
			else:
				return activeCombatantsInGroup($PartyStatusDisplay.getPlayerCombatants())
		else:
			if blueprint.can_revive:
				return $EnemyDisplayGrid.getEnemyCombatants()
			else:
				return activeCombatantsInGroup($EnemyDisplayGrid.getEnemyCombatants())
	else:
		push_error("Blueprint type unknown for: " + blueprint.getDialogDisplayName())
		return []


func activeCombatantsInGroup(combatant_list: Array) -> Array:
	var result: Array = []
	for combatant in combatant_list:
		if not combatant.isDefeated():
			result.append(combatant)
	return result


func executeBlueprint(user, blueprint: Blueprint, target) -> void:
	user.spendTP(blueprint.tp_cost)
	pushCombatantBattleMessages(user)
	
	if blueprint is BlueprintAttack:
		applyAttack(user, blueprint, target)
	elif blueprint is BlueprintSupport:
		applySupport(user, blueprint, target)
	else:
		push_error("Unknown blueprint type for " + blueprint.getDialogDisplayName())


func executeMultitargetBlueprint(user, blueprint: Blueprint, target_list: Array) -> void:
	user.spendTP(blueprint.tp_cost)
	pushCombatantBattleMessages(user)
	
	if blueprint is BlueprintAttack:
		for target in target_list:
			applyAttack(user, blueprint, target)
	elif blueprint is BlueprintSupport:
		for target in target_list:
			applySupport(user, blueprint, target)
	else:
		push_error("Unknown blueprint type for " + blueprint.getDialogDisplayName())


func applyAttack(user, blueprint: BlueprintAttack, target) -> void:
	for hit in range(blueprint.num_hits):
		if attackHits(user, blueprint, target):
			var raw_damage: int = user.rawAttackDamage(blueprint)
			var crit = attackCrits(user, blueprint, target)
			if crit:
				raw_damage *= 2
				$BattleMessageDisplay.pushBattleMessage("Critical hit!")
			target.receiveAttack(blueprint, raw_damage, crit)
			pushCombatantBattleMessages(target)
		else:
			$BattleMessageDisplay.pushBattleMessage("Missed!")


func applySupport(user, blueprint: BlueprintSupport, target) -> void:
	target.receiveSupport(blueprint, user == target)
	pushCombatantBattleMessages(target)


# Hit and crit rates are percentage based
func attackHits(user, blueprint: BlueprintAttack, target) -> bool:
	if blueprint.always_hit:
		return true
	var accuracy: int = clampi(user.rawAccuracy(blueprint) - target.hitEvasion(), MIN_ACCURACY, MAX_ACCURACY)
	return randi() % 100 < accuracy


func attackCrits(user, blueprint: BlueprintAttack, target) -> bool:
	if blueprint.always_hit:
		return false
	var crit_rate = clampi(user.rawCritRate(blueprint) - target.critEvasion(), MIN_CRIT, MAX_CRIT)
	return randi() % 100 < crit_rate


# Party is defeated when all members dead
func isPartyDefeated() -> bool:
	if party_ran:
		return true
	for morphose in $PartyStatusDisplay.getPlayerCombatants():
		if not morphose.isDefeated():
			return false
	return true


# Checks whether all enemies defeated
func allEnemiesDefeated() -> bool:
	for morphose in $EnemyDisplayGrid.getEnemyCombatants():
		if not morphose.isDefeated():
			return false
	return true


func isBattleOver() -> bool:
	return isPartyDefeated() or allEnemiesDefeated() or party_ran


# Returns Morphose who will act next
func getNextActor() -> Combatant:
	updateInitiatives()
	return getCombatantWithHighestAccumulatedSpeed()


func updateInitiatives() -> void:
	for array in [$PartyStatusDisplay.getPlayerCombatants(), $EnemyDisplayGrid.getEnemyCombatants()]:
		for combatant in array:
			if not combatant.isDefeated():
				combatant.generateAccumulatedSpeed()


func getCombatantWithHighestAccumulatedSpeed() -> Combatant:
	var max_accumulated_speed: int = -1
	
	# Get highest accumulated speed
	for array in [$PartyStatusDisplay.getPlayerCombatants(), $EnemyDisplayGrid.getEnemyCombatants()]:
		for combatant in array:
			if combatant.accumulated_speed > max_accumulated_speed and not combatant.isDefeated():
				max_accumulated_speed = combatant.accumulated_speed
	
	# Get all combatants with this accumulated speed
	var candidates: Array[Combatant] = []
	
	for array in [$PartyStatusDisplay.getPlayerCombatants(), $EnemyDisplayGrid.getEnemyCombatants()]:
		for combatant in array:
			if combatant.accumulated_speed == max_accumulated_speed and not combatant.isDefeated():
				candidates.append(combatant)
	
	# Break ties randomly
	return candidates[randi() % candidates.size()]


# How much bio-energy each party member gets after battle
func battleBioEnergyReward() -> int:
	
	var result = 0
	for enemy in $EnemyDisplayGrid.getEnemyCombatants():
		result += enemy.getBioEnergyReward()
		
	return ceili(float(result) / $PartyStatusDisplay.getPlayerCombatants().size())


func initializeTestFight() -> void:
	$PrepareForNextBattleButton.hide()
	$BattleMessageDisplay.close()
	buildPlayerCharacters()
	buildEnemies()
	setUpActionButtons()
	updateCombatantStatusDisplays()
	switchToActivePlayMode()


func buildPlayerCharacters() -> void:
	
	var party_members: Array[PartyCombatant]
	
	for party_member in ActiveSaveData.party_members:
		party_members.append(PartyCombatant.new(party_member))

	$PartyStatusDisplay.assignPartyMemberStatusDisplaysFromList(party_members)


func buildEnemies() -> void:
	
	var result: Array[EnemyCombatant] = []
	var enemies_with_base_name: Dictionary = {}
	
	var encounter_enemy_list = EncounterTable.getEncounterAtIndex(ActiveSaveData.current_battle)
	
	# If more than 1 enemy of a given type, update name to reflect this
	for enemy_type in encounter_enemy_list:
		var combatant = EnemyCombatant.new(enemy_type)
		if enemies_with_base_name.has(enemy_type.name):
			enemies_with_base_name[enemy_type.name] += 1
			combatant.name += " " + str(enemies_with_base_name[enemy_type.name])
		else:
			enemies_with_base_name[enemy_type.name] = 1
		result.append(combatant)
	
	$EnemyDisplayGrid.assignEnemyStatusDisplaysFromList(result)





func updateCombatantStatusDisplays() -> void:
	$PartyStatusDisplay.updatePartyMemberStatusDisplays()
	$EnemyDisplayGrid.updateEnemyStatusDisplays()


func pushCombatantBattleMessages(combatant) -> void:
	for message in combatant.retrieveBattleMessages():
		$BattleMessageDisplay.pushBattleMessage(message)


func showBattleMessages(remain_until_cleared: bool = false):
	if $BattleMessageDisplay.hasMessagesWaiting():
		$BattleMessageDisplay.displayMessages(remain_until_cleared)
		if not remain_until_cleared:
			await $BattleMessageDisplay.display_timeout


func setUpActionButtons() -> void:
	$BattleActionMenu.disable()	# Action buttons disabled until ready for player use


func disablePlayerControls():
	$BattleActionMenu.disable()
	$PartyStatusDisplay.deactivateSupportTargetButtons()
	$EnemyDisplayGrid.deactivateAttackTargetButtons()


func blueprintSelected(blueprint) -> void:
	selected_action = Combatant.ACTION.BLUEPRINT
	selected_blueprint = blueprint
	if blueprint.multitarget:
		$BattleMessageDisplay.pushBattleMessage(current_actor.name + " uses " + selected_blueprint.getDialogDisplayName() + ".")
		emit_signal("player_action_finalized")
	else:
		if blueprint is BlueprintAttack:
			$EnemyDisplayGrid.activateAttackTargetButtons()
		elif blueprint is BlueprintSupport:
			$PartyStatusDisplay.activateSupportTargetButtons(blueprint)


func attackPressed() -> void:
	$BattleActionMenu.displayAttackMenu(current_actor)
	$PartyStatusDisplay.deactivateSupportTargetButtons()
	$EnemyDisplayGrid.deactivateAttackTargetButtons()


func supportPressed() -> void:
	$BattleActionMenu.displaySupportMenu(current_actor)
	$PartyStatusDisplay.deactivateSupportTargetButtons()
	$EnemyDisplayGrid.deactivateAttackTargetButtons()


func waitPressed() -> void:
	selected_action = Combatant.ACTION.WAIT
	emit_signal("player_action_finalized")


func runPressed() -> void:
	selected_action = Combatant.ACTION.RUN
	emit_signal("player_action_finalized")


func switchToPlayAgainMode():
	$PrepareForNextBattleButton.show()


func switchToActivePlayMode():
	$PrepareForNextBattleButton.hide()


func selectEnemyAsAttackTarget(combatant) -> void:
	selected_target = combatant
	$BattleMessageDisplay.pushBattleMessage(current_actor.name + " uses " + selected_blueprint.getDialogDisplayName() + ".")
	emit_signal("player_action_finalized")


func _on_party_status_display_select_as_support_target(combatant) -> void:
	selected_target = combatant
	$BattleMessageDisplay.pushBattleMessage(current_actor.name + " uses " + selected_blueprint.getDialogDisplayName() + ".")
	emit_signal("player_action_finalized")


# Muta awarded per party member for defeating enemies
func victoryMuta() -> int:
	return ceili(float($EnemyDisplayGrid.getTotalBioEnergyReward()) / $PartyStatusDisplay.numberOfPartyMembers())


# Muta player gets per party member even if they lose
func consolationMuta() -> int:
	return ceili(victoryMuta() / 4)


func _on_prepare_for_next_battle_button_pressed() -> void:
	root.setActiveController("BuildCharacter")
