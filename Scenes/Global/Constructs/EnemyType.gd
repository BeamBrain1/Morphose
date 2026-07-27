class_name EnemyType
extends Morphose

const BASE_BIO_ENERGY_REWARD: int = 10

var support_priority: int = 5		# Priority bracket when AI targets support actions. Lower numbers always take priority

# Return the Muta value of the enemy upon its defeat 
func getBioEnergyValue() -> int:
	var blueprint_value: int = mostExpensiveBlueprintValue()
	
	var stat_average: int = (hp + tech_points) / 4
	
	for stat in [GlobalProgramData.COMBAT_STAT.ATTACK, GlobalProgramData.COMBAT_STAT.DEFENSE, GlobalProgramData.COMBAT_STAT.SENSES, GlobalProgramData.COMBAT_STAT.SPEED]:
		stat_average += getStatFromEnumType(stat)
	
	stat_average /= 6
	
	var stat_value = 0
	
	for i in range(stat_average):
		stat_value += i
	
	stat_value *= 6
	
	return BASE_BIO_ENERGY_REWARD + ceili(float(stat_value + blueprint_value)) / 8


func mostExpensiveBlueprintValue() -> int:
	var result: int = 0
	for blueprint in allBlueprints():
		if blueprint.bio_energy_cost > result:
			result = blueprint.bio_energy_cost
	
	return result
