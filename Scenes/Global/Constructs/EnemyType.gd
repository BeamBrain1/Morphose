class_name EnemyType
extends Morphose

const BASE_BIO_ENERGY_REWARD: int = 5

var support_priority: int = 5		# Priority bracket when AI targets support actions. Lower numbers always take priority
var never_crits: bool = false		# Some early enemy types could oneshot Primus with a lucky crit
var gives_bio_energy: bool = true	# Does this enemy give bio-energy upon defeat?
var is_boss: bool = false			# Bosses cannot be run from
var run_from_attempts_always_succeed: bool = false

# Used when deciding which blueprint to use.
#	Key: Blueprint
#	Value: An integer. Higher numbers = higher priority
var blueprint_priority_table: Dictionary = {}

# Return the Muta value of the enemy upon its defeat 
func getBioEnergyValue() -> int:
	
	if not gives_bio_energy:
		return 0
	
	var blueprint_value: int = mostExpensiveBlueprintValue()
	
	var stat_average: int = 0
	
	stat_average += (hp - HP_MINIMUM + tech_points - TP_MINIMUM) / 8
	
	for stat in [Morphose.COMBAT_STAT.ATTACK, Morphose.COMBAT_STAT.DEFENSE, Morphose.COMBAT_STAT.SENSES, Morphose.COMBAT_STAT.SPEED]:
		stat_average += getRawStatFromEnumType(stat)
	
	stat_average /= 6
	
	var stat_value = 0
	
	for i in range(stat_average):
		stat_value += i
	
	stat_value *= 6
	
	return BASE_BIO_ENERGY_REWARD + ceili(float(stat_value + blueprint_value)) / 8


func mostExpensiveBlueprintValue() -> int:
	var result: int = 0
	for blueprint in allBlueprints():
		if blueprint.getBioEnergyCost() > result:
			result = blueprint.getBioEnergyCost()
	
	return result


# Overrides parent
func installBlueprintByNameAndTier(bp_name: String, bp_tier: int, priority: int = 1) -> void:
	installBlueprint(Blueprint.getBlueprintFromGlobalList(bp_name, bp_tier), priority)


# Overrides parent
func installBlueprint(blueprint, priority: int = 1):
	super(blueprint)
	blueprint_priority_table[blueprint.base_display_name] = priority
