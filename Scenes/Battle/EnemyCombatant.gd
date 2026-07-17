class_name EnemyCombatant
extends Combatant

var base_type: EnemyType

const BASE_BIO_ENERGY_REWARD: int = 10
var number_in_battle: int = 1	# Number of instance of this enemy in battle, used to determine display name

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
	# If it has the TP to act, act. Otherwise, wait.
	if getPossibleBlueprintActions().size() > 0:
		return ACTION.BLUEPRINT
	else:
		return ACTION.WAIT


func chooseBlueprint(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	
	var result
	
	if base_type.name.matchn("QUEEN"):
		result = queenChooseBlueprint(party_combatants, enemy_combatants)
	else:	
		result = getPossibleBlueprintActions()[randi() % getPossibleBlueprintActions().size()]

	pushBattleMessage(name + " uses " + result.getDialogDisplayName() + ".")
	return result


func queenChooseBlueprint(party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Blueprint:
	var possible_actions = getPossibleBlueprintActions()
	if possible_actions.size() == 0:
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


# Choose target for single-target blueprint action
func chooseTarget(blueprint: Blueprint, target_list: Array, party_combatants: Array[PartyCombatant], enemy_combatants: Array[EnemyCombatant]) -> Combatant:
	return target_list[randi() % target_list.size()]


func mostExpensiveBlueprintValue() -> int:
	var result: int = 0
	for blueprint in allBlueprints():
		if blueprint.bio_energy_cost > result:
			result = blueprint.bio_energy_cost
	
	return result
