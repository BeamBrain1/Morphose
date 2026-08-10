class_name Morphose

const HP_CAP: int = 999
const HP_DIMINISHING_RETURNS_START: int = 400
const HP_MINIMUM: int = 10
const TP_CAP: int = 999
const TP_DIMINISHING_RETURNS_START: int = 400
const TP_MINIMUM: int = 10
const STAT_DIMINISHING_RETURNS_START: int = 120
const STAT_CAP: int = 250
const STAT_MINIMUM: int = 1

var name: String = "[NO DATA]"
var hp: int = HP_MINIMUM
var attack: int = STAT_MINIMUM
var defense: int = STAT_MINIMUM
var senses: int = STAT_MINIMUM
var speed: int = STAT_MINIMUM
var tech_points: int = TP_MINIMUM

var blueprints_attack: Array[BlueprintAttack] = []
var blueprints_support: Array[BlueprintSupport] = []
var blueprints_passive: Array[BlueprintPassive] = []


const BP_NAME_INDEX: int = 0
const BP_TIER_INDEX: int = 1


func installBlueprint(blueprint) -> void:
	if blueprint is BlueprintAttack:
		blueprints_attack.append(blueprint)
		blueprints_attack.sort_custom(Blueprint.sortBlueprintsAscending)
	elif blueprint is BlueprintSupport:
		blueprints_support.append(blueprint)
		blueprints_support.sort_custom(Blueprint.sortBlueprintsAscending)
	elif blueprint is BlueprintPassive:
		blueprints_passive.append(blueprint)
		blueprints_passive.sort_custom(Blueprint.sortBlueprintsAscending)
	else:
		push_error("Attempted to give Morphose " + name + " unrecognized blueprint")


func installBlueprintByNameAndTier(bp_name: String, bp_tier: int) -> void:
	installBlueprint(Blueprint.getBlueprintFromGlobalList(bp_name, bp_tier))


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


# Returns a list of all blueprints installed for this character
func allBlueprints() -> Array:
	var result = []
	for blueprint in blueprints_attack:
		result.append(blueprint)
	for blueprint in blueprints_support:
		result.append(blueprint)
	for blueprint in blueprints_passive:
		result.append(blueprint)
	return result
