class_name EnemyCombatant
extends Combatant

var base_type: EnemyType

var number_in_battle: int = 1	# Number of instance of this enemy in battle, used to determine display name
var support_priority: int
var ai_sequence: int = 0		# Used in cyclic AI decisions. Every action advances by 1 step

func _init(enemy_type: EnemyType):
	name = enemy_type.name
	hp = enemy_type.hp
	max_hp = hp
	tech_points = enemy_type.tech_points
	max_tp = tech_points
	attack = enemy_type.attack
	defense = enemy_type.defense
	senses = enemy_type.senses
	speed = enemy_type.speed
	support_priority = enemy_type.support_priority
	never_crits = enemy_type.never_crits
	base_type = enemy_type
	
	blueprints_attack = enemy_type.blueprints_attack
	blueprints_support = enemy_type.blueprints_support
	blueprints_passive = enemy_type.blueprints_passive


func getDisplayName() -> String:
	if number_in_battle == 1:
		return name
	else:
		return name + " " + str(number_in_battle)

# Determines how much bio-energy this combatant awards upon defeat
# Determined by combined stats and value of installed blueprints
func getBioEnergyReward() -> int:
	return base_type.getBioEnergyValue()


func getStatFromEnumType(stat: GlobalProgramData.COMBAT_STAT) -> int:
	if stat == GlobalProgramData.COMBAT_STAT.HP:
		return hp
	if stat == GlobalProgramData.COMBAT_STAT.ATTACK:
		return attack
	if stat == GlobalProgramData.COMBAT_STAT.DEFENSE:
		return defense
	if stat == GlobalProgramData.COMBAT_STAT.SENSES:
		return senses
	if stat == GlobalProgramData.COMBAT_STAT.SPEED:
		return speed
	if stat == GlobalProgramData.COMBAT_STAT.TECH_POINTS:
		return tech_points
	push_error("Unrecognized stat: " + str(stat))
	return 0


func chooseAction(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> ACTION:
	
	ai_sequence += 1	# For code simplicity, sequence updated at beginning of turn. This effectively makes it 1-indexed
	
	if base_type.name.matchn("SILO LORD"):
		return siloLordChooseAction()
	# If it has the TP to act, act. Otherwise, wait.
	if getPossibleBlueprintActions().size() > 0:
		return ACTION.BLUEPRINT
	else:
		return ACTION.WAIT


# Silo lord only uses highest-tier attacks
func siloLordChooseAction() -> ACTION:
	# If it has the TP to act, act. Otherwise, wait.
	if Blueprint.blueprintIsInList(getPossibleBlueprintActions(), "Missile", 2):
		return ACTION.BLUEPRINT
	return ACTION.WAIT


func chooseBlueprint(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	
	var result
	
	if base_type.name.matchn("QUEEN"):
		result = queenChooseBlueprint(party_combatants, enemy_combatants)
	elif base_type.name.matchn("SILO LORD"):
		result = siloLordChooseBlueprint(party_combatants)
	elif base_type.name.matchn("KING CRAB"):
		result = kingCrabChooseBlueprint()
	elif base_type.name.matchn("ZENITH"):
		result = zenithChooseBlueprint()
	else:
		result = getPossibleBlueprintActions()[randi() % getPossibleBlueprintActions().size()]

	pushBattleMessage(name + " uses " + result.getDialogDisplayName() + ".")
	return result


func queenChooseBlueprint(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	var possible_actions = getPossibleBlueprintActions()
	if possible_actions.size() == 1:
		return possible_actions[0]
	else:
		var living_enemies: int = 0
		for enemy in enemy_combatants:
			if not enemy.isDefeated():
				living_enemies += 1
		if living_enemies < 5:
			return Blueprint.getBlueprintFromList(possible_actions, "Swarm")
		else:
			return Blueprint.getBlueprintFromList(possible_actions, "Marshal")


func siloLordChooseBlueprint(party_combatants: Array[PartyCombatant]) -> Blueprint:
	var possible_actions = getPossibleBlueprintActions()
	
	var party_avg_defense: int = 0
	var living_party_members: int = 0
	
	for combatant in party_combatants:
		if not combatant.isDefeated():
			party_avg_defense += combatant.getStatusEffectAdjustedDefense()
			living_party_members += 1
	
	party_avg_defense /= maxi(living_party_members, 1)
	
	if Blueprint.blueprintIsInList(possible_actions, "Missile", 2) and party_avg_defense > 40:
		return Blueprint.getBlueprintFromList(possible_actions, "Missile", 2)
	elif Blueprint.blueprintIsInList(possible_actions, "FragBomb", 2):
		return Blueprint.getBlueprintFromList(possible_actions, "FragBomb", 2)
	else:
		return possible_actions[randi() % possible_actions.size()]


func kingCrabChooseBlueprint() -> Blueprint:
	if ai_sequence % 2 == 0:
		if getPossibleAttackActions().size() > 0:
			return getPossibleAttackActions()[randi() % getPossibleAttackActions().size()]
	else:
		if getPossibleSupportActions().size() > 0:
			if Blueprint.blueprintIsInList(getPossibleSupportActions(), "Marshal", 2) and hardened_stacks == MAX_STATUS_EFFECT_STACKS:
				return Blueprint.getBlueprintFromList(getPossibleSupportActions(), "Marshal", 2)
			else:
				return getPossibleSupportActions()[randi() % getPossibleSupportActions().size()]
	return getPossibleBlueprintActions()[randi() % getPossibleBlueprintActions().size()]


func zenithChooseBlueprint() -> Blueprint:
	if ai_sequence == 1:		# Start battle by using Perfect
		return Blueprint.getBlueprintFromList(getPossibleBlueprintActions(), "Perfect", 1)
	elif ai_sequence % 2 == 1:	# Use a strong blueprint
		var action_list: Array = []
		for blueprint in getPossibleBlueprintActions():
			if blueprint.base_display_name.matchn("Perfect"):
				if biggestDebuff() >= 5:					# Only use Perfect if buff balance falls below a certain point
					return blueprint
				if sumOfBuffs() < 3:		# Add it to move pool if buff balance falls below a certain point
					action_list.append(blueprint)
			elif blueprint.isZenithBlueprint():
				action_list.append(blueprint)
		return action_list[randi() % action_list.size()]
	else:						# Use a regular blueprint
		var action_list: Array = []
		for blueprint in getPossibleBlueprintActions():
			if not blueprint.isZenithBlueprint():
				action_list.append(blueprint)
		return action_list[randi() % action_list.size()]


# Choose target for single-target blueprint action
func chooseTarget(blueprint, target_list: Array, party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Combatant:
	if blueprint is BlueprintSupport:
		return chooseSupportTarget(blueprint, enemy_combatants)
	return target_list[randi() % target_list.size()]


func chooseSupportTarget(blueprint, enemy_combatants: Array[EnemyCombatant]) -> Combatant:
	var highest_priority: int = 1000
	for combatant in enemy_combatants:
		if not combatant.isDefeated():
			highest_priority = mini(highest_priority, combatant.support_priority)
	var target_list = []
	for combatant in enemy_combatants:
		if combatant.support_priority == highest_priority and not combatant.isDefeated():
			target_list.append(combatant)
	return target_list[randi() % target_list.size()]


func mostExpensiveBlueprintValue() -> int:
	var result: int = 0
	for blueprint in allBlueprints():
		if blueprint.bio_energy_cost > result:
			result = blueprint.bio_energy_cost
	
	return result
