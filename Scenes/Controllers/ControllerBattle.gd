extends Controller


signal target_selected
signal player_action_finalized	# Emitted once player has all necessary choices (action, possibly blueprint, possibly target) to select party member action

var current_actor
var selected_action: Combatant.ACTION
var selected_blueprint
var selected_target

var party_ran: bool = false		# Party made a successful escape attempt
var battle_won: bool = false

const ATTACK_ANIM_TO_HIT_ANIM_DELAY: float = 0.25
const PARTY_MEMBER_HIT_SCREEN_SHAKE_SMALLEST_OFFSET: int = 8
const PARTY_MEMBER_HIT_SCREEN_SHAKE_NUMBER: int = 2
const PARTY_MEMBER_HIT_SCREEN_SHAKE_INTERVAL: float = 0.125
const PARTY_MEMBER_HIT_SCREEN_SHAKE_INITIAL_DIRECTION: Vector2 = Vector2.DOWN

signal battle_result


func mainLoop():

	while true:
		selected_action = Combatant.ACTION.NULL
		selected_blueprint = null
		selected_target = null
		current_actor = getNextActor()
		current_actor.beginTurn()

		pushCombatantBattleMessages(current_actor)
		updateCombatantStatusDisplays()

		if isBattleOver():	# Character may have died from poison, so check here
			break
		else:
			if current_actor is PartyCombatant:
				await showBattleMessages()

		$PartyStatusDisplay.toggleTurnIndicators(current_actor)

		if not current_actor.isDefeated():
			await chooseAction(current_actor)
			await displayAndRunChosenAction(current_actor, selected_action, selected_blueprint, selected_target)

		$PartyStatusDisplay.toggleTurnIndicators(current_actor)

		current_actor.endTurn()
		if not isBattleOver():
			pushCombatantBattleMessages(current_actor)
		await showBattleMessages(true)

		# Check if battle is over after each action
		if isBattleOver():	# Character may have died from poison
			break

	# Battle end routine
	if party_ran:
		await battleFled()
	elif isPartyDefeated():
		await battleLost()
	elif allEnemiesDefeated():
		await battleWon()
	switchToOverworldController()


func battleFled() -> void:
	$BattleMessageDisplay.pushBattleMessage("Successfully escaped.")
	battle_won = false
	await showBattleMessages(true)
	emit_signal("battle_result", battle_won)


# Run this if player lost battle
func battleLost() -> void:
	$BattleMessageDisplay.pushBattleMessage("You lose!")
	battle_won = false
	await showBattleMessages(true)
	emit_signal("battle_result", battle_won)


# Run this if player won battle
func battleWon() -> void:
	$BattleMessageDisplay.pushBattleMessage("You win!")
	await showBattleMessages(true, false, true)
	await $EnemyDisplayGrid.eatEnemies()
	$BattleMessageDisplay.pushBattleMessage("Harvested " + str(victoryMuta()) + " Muta.")
	ActiveSaveData.party.awardMuta(victoryMuta())
	battle_won = true
	await showBattleMessages(true, true)
	emit_signal("battle_result", battle_won)


# Current actor chooses action; parameters assigned for execution
func chooseAction(current_actor) -> void:
	if current_actor is PartyCombatant:
		$BattleActionMenu.enableUseableButtons(current_actor)
		await player_action_finalized
		disablePlayerControls()
	else:
		selected_action = current_actor.chooseAction($PartyStatusDisplay.getPlayerCombatants(), $EnemyDisplayGrid.getEnemyCombatants())
		if selected_action == Combatant.ACTION.BLUEPRINT:
			selected_blueprint = current_actor.chooseBlueprintOrNull($PartyStatusDisplay.getPlayerCombatants(), $EnemyDisplayGrid.getEnemyCombatants())
			if selected_blueprint != null:
				if not selected_blueprint.multitarget:
					selected_target = current_actor.chooseTargetOrNull(selected_blueprint, getTargetList(current_actor, selected_blueprint), $PartyStatusDisplay.getPlayerCombatants(), $EnemyDisplayGrid.getEnemyCombatants())


# 	Not all actions will have assigned blueprints or targets
# 	e.g. multitarget attacks have no assigned target, wait/run has no blueprint
func displayAndRunChosenAction(actor, action: Combatant.ACTION, blueprint = null, target = null):
	
	# Failsafe: if blueprint chosen but no available blueprints, wait
	var finalized_action: Combatant.ACTION = action
	if blueprint == null and action == Combatant.ACTION.BLUEPRINT:
		finalized_action = Combatant.ACTION.WAIT
	if finalized_action == Combatant.ACTION.WAIT:
		actor.wait()
		pushCombatantBattleMessages(actor)
	elif finalized_action == Combatant.ACTION.RUN:
		actor.run()
		pushCombatantBattleMessages(actor)
		if attemptRun():
			party_ran = true
			$BattleMessageDisplay.pushBattleMessage("The party escaped!")
		else:
			$BattleMessageDisplay.pushBattleMessage("Failed to escape!")
	elif finalized_action == Combatant.ACTION.BLUEPRINT:
		if blueprint.multitarget:
			await executeMultitargetBlueprint(actor, blueprint, getTargetList(actor, blueprint))
		elif blueprint is BlueprintSupport and blueprint.self_only:
			await executeBlueprint(actor, blueprint, actor)
		else:
			await executeBlueprint(actor, blueprint, target)
	else:
		push_error("Unprocessed action: " + str(action))


func getTargetList(combatant: Combatant, blueprint: Blueprint) -> Array:
	if blueprint is BlueprintAttack:
		if combatant is PartyCombatant:
			return activeCombatantsInGroup($EnemyDisplayGrid.getEnemyCombatants())
		else:
			return activeCombatantsInGroup($PartyStatusDisplay.getPlayerCombatants())
	elif blueprint is BlueprintSupport:
		if blueprint.self_only:
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
	user.spendTP(blueprint.getTechPointCost())
	pushCombatantBattleMessages(user)
	await showBattleMessages(false, false, true)
	
	await playBlueprintUseAnimation(user, blueprint, target)
	
	if blueprint is BlueprintAttack:
		await applyAttack(user, blueprint, target)
	elif blueprint is BlueprintSupport:
		await applySupport(user, blueprint, target)
	else:
		push_error("Unknown blueprint type for " + blueprint.getDialogDisplayName())
	if blueprint.special.matchn("swarm"):
		specialReinforce("Swarmer", 4)
	elif blueprint.special.matchn("bud"):
		specialReinforce("Z-Spawn", 4)
	updateCombatantStatusDisplays()


func specialReinforce(enemy_type: String, num_joiners: int) -> void:
	for i in range(num_joiners):
		var enemy = EnemyTable.getEnemyByName(enemy_type)
		$EnemyDisplayGrid.addEnemy(enemy)
	$BattleMessageDisplay.pushBattleMessage(enemy_type + "s joined the battle!")


func executeMultitargetBlueprint(user, blueprint: Blueprint, target_list: Array) -> void:
	user.spendTP(blueprint.getTechPointCost())
	pushCombatantBattleMessages(user)
	await showBattleMessages(false, false, true)
	
	await playBlueprintUseAnimation(user, blueprint)
	
	if blueprint is BlueprintAttack:
		for target in target_list:
			if not target.isDefeated():
				await applyAttack(user, blueprint, target, target == target_list.back())
	elif blueprint is BlueprintSupport:
		for target in target_list:
			await applySupport(user, blueprint, target, target == target_list.back())
	else:
		push_error("Unknown blueprint type for " + blueprint.getDialogDisplayName())


func playBlueprintUseAnimation(user, blueprint, target = null):
	if blueprint.hasAnimation():
		var attack_anim: AttackAnimation = blueprint.getUseAnimation()
		$EnemyDisplayGrid.add_child(attack_anim)	# We put it here so it doesn't draw over battle action menu or message display
		if target is EnemyCombatant:	# Center single-target player attacks on enemy sprite
			attack_anim.global_position = $EnemyDisplayGrid.getCombatantDisplay(target).global_position
		elif user is PartyCombatant and blueprint is BlueprintAttack and blueprint.multitarget:
			pass	# For multitarget attacks launched by party, show but do not change position
		else:	# Visible animations don't play for enemy attacks or any support abilities
			attack_anim.hide()
		attack_anim.start(user is EnemyCombatant)
		await attack_anim.finished_playing


# last_target: is this combatant the last target of the blueprint (always true for single-target blueprints)?
func applyAttack(user, blueprint: BlueprintAttack, target, last_target: bool = true) -> void:
	
	var successful_hits: int = 0
	var critical_hits: int = 0
	var damage: int = 0
	
	for hit in range(blueprint.num_hits):
		if user.attackHits(blueprint, target):
			successful_hits += 1
			var raw_damage: int = user.rawAttackDamage(blueprint)
			var crit = user.attackCrits(blueprint, target)
			if crit:
				critical_hits += 1
				raw_damage *= 2
			target.receiveHit(blueprint, raw_damage, crit)

	damage = target.finishReceivingAttack(blueprint.damageless)

	if successful_hits > 0:
		await get_tree().create_timer(ATTACK_ANIM_TO_HIT_ANIM_DELAY).timeout
		if target is EnemyCombatant:
			if blueprint.damageless or damage > 0:
				await $EnemyDisplayGrid.getCombatantDisplay(target).hitFlash()
			else:
				await $EnemyDisplayGrid.getCombatantDisplay(target).hitNoDamage()
		else:
			if blueprint.damageless or damage > 0:
				await partyMemberHitScreenShake()
			else:
				await partyMemberHitNoDamage()
	pushCombatantBattleMessages(target)
	await showBattleMessages(last_target, true, not last_target)
	if target is EnemyCombatant:
		$EnemyDisplayGrid.getCombatantDisplay(target).updateDisplay()


# last_target: is this combatant the last target of the blueprint (always true for single-target blueprints)?
func applySupport(user, blueprint: BlueprintSupport, target, last_target: bool = true) -> void:
	target.receiveSupport(blueprint, user == target)
	await get_tree().create_timer(ATTACK_ANIM_TO_HIT_ANIM_DELAY).timeout
	pushCombatantBattleMessages(target)
	await showBattleMessages(last_target, true, not last_target)
	if target is EnemyCombatant:
		$EnemyDisplayGrid.getCombatantDisplay(target).updateDisplay()


# Party is defeated when all members dead
func isPartyDefeated() -> bool:
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


func initializeBattle(enemy_list: Array) -> void:
	$BattleMessageDisplay.close()
	buildPlayerCharacters()
	buildEnemies(enemy_list)
	setUpActionButtons()
	updateCombatantStatusDisplays()
	mainLoop()


func buildPlayerCharacters() -> void:
	
	var party_members: Array[PartyCombatant]
	
	for party_member in ActiveSaveData.party.members:
		party_members.append(PartyCombatant.new(party_member))

	$PartyStatusDisplay.assignPartyMemberStatusDisplaysFromList(party_members)


func buildEnemies(enemy_list: Array) -> void:
	$EnemyDisplayGrid.assignEnemyStatusDisplaysFromList(enemy_list)


func updateCombatantStatusDisplays() -> void:
	$PartyStatusDisplay.updatePartyMemberStatusDisplays()
	$EnemyDisplayGrid.updateEnemyStatusDisplays()


func pushCombatantBattleMessages(combatant) -> void:
	for message in combatant.retrieveBattleMessages():
		$BattleMessageDisplay.pushBattleMessage(message)


func showBattleMessages(manual_clear_only: bool = false, append: bool = false, persist: bool = false, force_show: bool = false):
	if $BattleMessageDisplay.hasMessagesWaiting() or force_show:
		$BattleMessageDisplay.displayMessages(manual_clear_only, append, persist)
		await $BattleMessageDisplay.end_display


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
		$BattleMessageDisplay.pushBattleMessage(current_actor.getName() + " uses " + selected_blueprint.getDialogDisplayName() + ".")
		emit_signal("player_action_finalized")
	else:
		if blueprint is BlueprintAttack:
			$EnemyDisplayGrid.activateAttackTargetButtons()
		elif blueprint is BlueprintSupport:
			if blueprint.self_only:
				selectSupportTarget(current_actor)
			else:
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


func selectEnemyAsAttackTarget(combatant) -> void:
	selected_target = combatant
	$BattleMessageDisplay.pushBattleMessage(current_actor.getName() + " uses " + selected_blueprint.getDialogDisplayName() + ".")
	emit_signal("player_action_finalized")


func selectSupportTarget(combatant) -> void:
	selected_target = combatant
	$BattleMessageDisplay.pushBattleMessage(current_actor.getName() + " uses " + selected_blueprint.getDialogDisplayName() + ".")
	emit_signal("player_action_finalized")


# Muta awarded per party member for defeating enemies
func victoryMuta() -> int:
	return ceili(float($EnemyDisplayGrid.getTotalBioEnergyReward()) / $PartyStatusDisplay.numberOfPartyMembers())


# Attempt to run from battle. Returns true if successful, false if failed. Auto-fails if boss fight
func attemptRun() -> bool:
	if $EnemyDisplayGrid.encounterHasBoss():
		return false
	if $EnemyDisplayGrid.canAlwaysRunFromEncounter():
		return true
	var party_run_points = $PartyStatusDisplay.getPartyRunPoints()
	var enemy_catch_points = $EnemyDisplayGrid.getEnemyCatchPoints()
	return randi() % (party_run_points + enemy_catch_points) < party_run_points


func partyMemberHitScreenShake() -> void:
	$AudioPartyMemberHit.play()
	var initial_position: Vector2 = position
	for i in range(PARTY_MEMBER_HIT_SCREEN_SHAKE_NUMBER):
		# Start with large shake, then draw down to normal position
		var position_change: Vector2 = PARTY_MEMBER_HIT_SCREEN_SHAKE_INITIAL_DIRECTION * (PARTY_MEMBER_HIT_SCREEN_SHAKE_SMALLEST_OFFSET * (PARTY_MEMBER_HIT_SCREEN_SHAKE_NUMBER - i))
		# Alternate directions
		if i % 2 == 1:
			position_change *= -1
		position = initial_position + position_change
		await get_tree().create_timer(PARTY_MEMBER_HIT_SCREEN_SHAKE_INTERVAL).timeout
	position = initial_position


func partyMemberHitNoDamage() -> void:
	$AudioPartyMemberHitNoDamage.play()
	await $AudioPartyMemberHitNoDamage.finished
