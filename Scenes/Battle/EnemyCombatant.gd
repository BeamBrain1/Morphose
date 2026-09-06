class_name EnemyCombatant
extends Combatant

var number_in_battle: int = 1	# Number of instance of this enemy in battle, used to determine display name
var ai_sequence: int = 0		# Used in cyclic AI decisions. Every action advances by 1 step

func _init(morphose_in):
	morphose = morphose_in
	initializeHP()
	initializeTP()


func getName() -> String:
	if number_in_battle == 1:
		return morphose.name
	else:
		return morphose.name + " " + str(number_in_battle)

# Determines how much bio-energy this combatant awards upon defeat
# Determined by combined stats and value of installed blueprints
func getBioEnergyReward() -> int:
	return morphose.getBioEnergyValue()


func chooseAction(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> ACTION:
	
	ai_sequence += 1	# For code simplicity, sequence updated at beginning of turn. This effectively makes it 1-indexed
	return ACTION.BLUEPRINT


func chooseBlueprintOrNull(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	
	var result
	
	if morphose.name.matchn("GANG BOSS"):
		result = gangBossChooseBlueprint()
	elif morphose.name.matchn("QUEEN"):
		result = queenChooseBlueprint(party_combatants, enemy_combatants)
	elif morphose.name.matchn("SILO LORD"):
		result = siloLordChooseBlueprint(party_combatants)
	elif morphose.name.matchn("TANKER"):
		result = tankerChooseBlueprint(enemy_combatants)
	elif morphose.name.matchn("SNIPER"):
		result = sniperChooseBlueprint()
	elif morphose.name.matchn("KING CRAB"):
		result = kingCrabChooseBlueprint()
	elif morphose.name.matchn("PROMETHEUS"):
		result = prometheusChooseBlueprint()
	elif morphose.name.matchn("ZENITH"):
		result = zenithChooseBlueprint(enemy_combatants)
	else:
		result = chooseBlueprintOrNullFromList(getPossibleBlueprintActions())

	if result != null:
		pushBattleMessage(getName() + " uses " + result.getDialogDisplayName() + ".")
	return result


func gangBossChooseBlueprint() -> Blueprint:
	
	if ai_sequence % 4 == 1:
		if canUseBlueprint(getBlueprint("Numb Gas")):
			return getBlueprint("Numb Gas")
		return chooseBlueprintOrNullFromList(getPossibleBlueprintActions())
	else:
		var choice_list = []
		for blueprint in getPossibleBlueprintActions():
			if not blueprint.base_display_name.matchn("Numb Gas"):
				choice_list.append(blueprint)
		return chooseBlueprintOrNullFromList(choice_list)


func queenChooseBlueprint(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	var action_list = getPossibleBlueprintActions()
	if action_list.size() < 2:
		return chooseBlueprintOrNullFromList(action_list)
	else:
		var living_enemies: int = 0
		for enemy in enemy_combatants:
			if not enemy.isDefeated():
				living_enemies += 1
		if living_enemies < 5:
			return getBlueprint("Swarm")
		else:
			return getBlueprint("Marshal")


func siloLordChooseBlueprint(party_combatants: Array[PartyCombatant]) -> Blueprint:
	var possible_actions = getPossibleBlueprintActions()
	
	var party_avg_defense: int = 0
	var living_party_members: int = 0
	
	for combatant in party_combatants:
		if not combatant.isDefeated():
			party_avg_defense += combatant.getStatusEffectAdjustedDefense()
			living_party_members += 1
	
	party_avg_defense /= maxi(living_party_members, 1)
	
	if Blueprint.blueprintIsInList(possible_actions, "Missile", 2) and party_avg_defense > 30:
		return getBlueprint("Missile", 2)
	elif Blueprint.blueprintIsInList(possible_actions, "FragBomb", 2):
		return getBlueprint("FragBomb", 2)
	else:
		return null


func tankerChooseBlueprint(enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	var silo_lord: EnemyCombatant = null
	for combatant in enemy_combatants:
		if combatant.morphose.name.matchn("SILO LORD") and not combatant.isDefeated():
			silo_lord = combatant
			break
	
	if silo_lord == null:	# If Silo Lord absent or defeated, act randomly
		return chooseBlueprintOrNullFromList(getPossibleBlueprintActions())
	if silo_lord.biggestBuff() < 2 and canUseBlueprint(getBlueprint("Turbo")):
		return getBlueprint("Turbo")
	
	var choice_list: Array = []
	for blueprint in getPossibleBlueprintActions():
		choice_list.append(blueprint)
	return chooseBlueprintOrNullFromList(choice_list)


func sniperChooseBlueprint() -> Blueprint:
	if sumOfBuffs() < 5:
		if canUseBlueprint(getBlueprint("Bullseye")):
			return getBlueprint("Bullseye")
	else:
		if canUseBlueprint(getBlueprint("Laser")):
			return getBlueprint("Laser")
	return chooseBlueprintOrNullFromList(getPossibleBlueprintActions())


func kingCrabChooseBlueprint() -> Blueprint:
	if ai_sequence % 2 == 0:
		return chooseBlueprintOrNullFromList(getPossibleAttackActions())
	else:
		if getPossibleSupportActions().size() > 0:
			if canUseBlueprint(getBlueprint("Marshal")) and sharpened_stacks < hardened_stacks:
				return getBlueprint("Marshal", 3)
			elif canUseBlueprint(getBlueprint("Formation")) and hardened_stacks < sharpened_stacks:
				return getBlueprint("Formation", 3)
			else:
				return chooseBlueprintOrNullFromList(getPossibleSupportActions())
	return chooseBlueprintOrNullFromList(getPossibleBlueprintActions())


func prometheusChooseBlueprint() -> Blueprint:
	if ai_sequence % 4 == 1:
		if canUseBlueprint(getBlueprint("Recombine")):
			return getBlueprint("Recombine")
	return chooseBlueprintOrNullFromList(getPossibleBlueprintActions())


func zenithChooseBlueprint(enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	var action_list: Array = []
	if ai_sequence == 1:		# Start battle by using Perfect
		return getBlueprint("Perfect", 1)
	elif ai_sequence % 2 == 1:	# Use a unique blueprint
		if hp > getMaxHP() * 3 / 4:
			return getBlueprint("Mind Rip", 1)
		elif hp > getMaxHP() * 1 / 2:
			if ai_sequence < 5000 and canUseBlueprint(getBlueprint("Bud")):
				ai_sequence += 5000			# First time falling below 75% HP, use Bud ASAP
				return getBlueprint("Bud")
			else:
				addBlueprintToActionListIfUseable(action_list, "Mind Rip")
				addBlueprintToActionListIfUseable(action_list, "Crush")
				if enemy_combatants.size() < 5:
					addBlueprintToActionListIfUseable(action_list, "Bud")
				if sumOfBuffs() < 1:	# Consider using Perfect is buffs too low
					addBlueprintToActionListIfUseable(action_list, "Perfect")
		else:
			if ai_sequence < 10000 and canUseBlueprint(getBlueprint("FusionBomb")):
				ai_sequence += 10000		# First time falling below 50% HP, use FusionBomb ASAP
				return getBlueprint("FusionBomb")
			else:
				addBlueprintToActionListIfUseable(action_list, "Mind Rip")
				addBlueprintToActionListIfUseable(action_list, "Crush")
				if enemy_combatants.size() < 5:
					addBlueprintToActionListIfUseable(action_list, "Bud")
				addBlueprintToActionListIfUseable(action_list, "FusionBomb")
				if sumOfBuffs() < 4:	# Consider using Perfect is buffs too low (higher threshold)
					addBlueprintToActionListIfUseable(action_list, "Perfect")
		return chooseBlueprintOrNullFromList(action_list)
	else:						# Use a regular blueprint
		for blueprint in getPossibleBlueprintActions():
			if not blueprint.isZenithBlueprint():
				action_list.append(blueprint)
	return chooseBlueprintOrNullFromList(action_list)


# Choose target for single-target blueprint action
# Returns null if null blueprint supplied
func chooseTargetOrNull(blueprint, target_list: Array, party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Combatant:
	if blueprint == null:
		return null
	if blueprint is BlueprintSupport:
		return chooseSupportTarget(blueprint, enemy_combatants)
	return target_list[randi() % target_list.size()]


func chooseSupportTarget(blueprint, enemy_combatants: Array[EnemyCombatant]) -> Combatant:
	
	if morphose.name.matchn("SNIPER"):
		return sniperChooseSupportTarget()
		
	var highest_priority: int = 1000
	for combatant in enemy_combatants:
		if not combatant.isDefeated():
			highest_priority = mini(highest_priority, combatant.morphose.support_priority)
	var target_list = []
	for combatant in enemy_combatants:
		if combatant.morphose.support_priority == highest_priority and not combatant.isDefeated():
			target_list.append(combatant)
	return target_list[randi() % target_list.size()]


func sniperChooseSupportTarget() -> Combatant:
	return self


#	Choose a blueprint from a list, or null if the list is empty
func chooseBlueprintOrNullFromList(blueprint_list: Array) -> Blueprint:
	var prioritized_list: Array = []
	for bp in blueprint_list:
		for i in range(morphose.blueprint_priority_table[bp.base_display_name]):
			prioritized_list.append(bp)
	if prioritized_list.is_empty():
		return null
	return prioritized_list[randi() % prioritized_list.size()]


# Catch points make it more difficult for player characters to escape battle
func catchPoints() -> int:
	if isDefeated():
		return 0
	else:
		return getStatusEffectAdjustedSpeed()


func isBoss() -> bool:
	return morphose.is_boss
