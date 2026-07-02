class_name EnemyCombatant
extends Combatant


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
	
	blueprints_attack = enemy_type.blueprints_attack
	blueprints_support = enemy_type.blueprints_support
	blueprints_passive = enemy_type.blueprints_passive


# Determines how much bio-energy this combatant awards upon defeat
# Determined by combined stats and value of installed blueprints
func getBioEnergyReward() -> int:
	var result: int = 0
	
	for blueprint in allBlueprints():
		result += blueprint.bio_energy_cost
	
	for stat in [GlobalProgramData.COMBAT_STAT.HP, GlobalProgramData.COMBAT_STAT.ATTACK, GlobalProgramData.COMBAT_STAT.DEFENSE, GlobalProgramData.COMBAT_STAT.SENSES, GlobalProgramData.COMBAT_STAT.SPEED, GlobalProgramData.COMBAT_STAT.TECH_POINTS]:
		result += getStatBioEnergyValue(stat)
	
	return maxi(1, ceili(float(result) / 4))


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


func getStatBioEnergyValue(stat: GlobalProgramData.COMBAT_STAT) -> int:
	
	var stat_value: int = getStatFromEnumType(stat)
	
	var result: int = 0
	
	for i in range(stat_value):
		result += i
	
	if stat in [GlobalProgramData.COMBAT_STAT.HP, GlobalProgramData.COMBAT_STAT.TECH_POINTS]:
		result = ceili(result / 2)
	
	return result


func chooseAction() -> ACTION:
	# If it has the TP to act, act. Otherwise, wait.
	if getPossibleBlueprintActions().size() > 0:
		return ACTION.BLUEPRINT
	else:
		return ACTION.WAIT


func chooseBlueprint() -> Blueprint:
	var result = getPossibleBlueprintActions()[randi() % getPossibleBlueprintActions().size()]
	pushBattleMessage(name + " uses " + result.getDialogDisplayName() + ".")
	return result


# Choose target for single-target blueprint action
func chooseTarget(blueprint: Blueprint, target_list: Array) -> Combatant:
	return target_list[randi() % target_list.size()]
