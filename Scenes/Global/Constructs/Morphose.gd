class_name Morphose

var name: String = "[NO DATA]"
var hp: int
var attack: int
var defense: int
var senses: int
var speed: int
var tech_points: int

const HP_MINIMUM: int = 10
const TP_MINIMUM: int = 10
const STAT_MINIMUM: int = 1

var blueprints_attack: Array[BlueprintAttack] = []
var blueprints_support: Array[BlueprintSupport] = []
var blueprints_passive: Array[BlueprintPassive] = []


const BP_NAME_INDEX: int = 0
const BP_TIER_INDEX: int = 1


enum COMBAT_STAT {HP, ATTACK, DEFENSE, SENSES, SPEED, TECH_POINTS}


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


func getRawStatFromEnumType(stat: COMBAT_STAT) -> int:
	if stat == COMBAT_STAT.HP:
		return hp
	if stat == COMBAT_STAT.ATTACK:
		return attack
	if stat == COMBAT_STAT.DEFENSE:
		return defense
	if stat == COMBAT_STAT.SENSES:
		return senses
	if stat == COMBAT_STAT.SPEED:
		return speed
	if stat == COMBAT_STAT.TECH_POINTS:
		return tech_points
	push_error("Unrecognized stat: " + str(stat))
	return 0


func getStatFromEnumType(stat: COMBAT_STAT) -> int:
	var result = getRawStatFromEnumType(stat)
	if stat == COMBAT_STAT.HP and hasPassiveBlueprintWithSpecial("Boost-HP"):
		result += getBlueprint("Boost-HP").value
	elif stat == COMBAT_STAT.ATTACK and hasPassiveBlueprintWithSpecial("Boost-AT"):
		result += getBlueprint("Boost-AT").value
	elif stat == COMBAT_STAT.DEFENSE and hasPassiveBlueprintWithSpecial("Boost-DF"):
		result += getBlueprint("Boost-DF").value
	elif stat == COMBAT_STAT.SENSES and hasPassiveBlueprintWithSpecial("Boost-SE"):
		result += getBlueprint("Boost-SE").value
	elif stat == COMBAT_STAT.SPEED and hasPassiveBlueprintWithSpecial("Boost-SP"):
		result += getBlueprint("Boost-SP").value
	elif stat == COMBAT_STAT.TECH_POINTS and hasPassiveBlueprintWithSpecial("Boost-TP"):
		result += getBlueprint("Boost-TP").value
	return result


func getBlueprint(bp_name: String, bp_tier = 0):
	return Blueprint.getBlueprintFromList(allBlueprints(), bp_name, bp_tier)


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


# Return true if Morphose has the blueprint with the specified name
# If tier left default, not checked. Otherwise, checked for exact match
func hasPassiveBlueprintWithSpecial(special_name: String, tier_in: int = 0) -> bool:
	for bp in blueprints_passive:
		if bp.special.matchn(special_name):
			if tier_in == 0 or bp.tier == tier_in:
				return true
	return false


# Returns tier of passive blueprint, or null and -1 if blueprint not found
func passiveBlueprintTier(bp_name: String) -> int:
	for bp in blueprints_passive:
		if bp.base_display_name.matchn(bp_name):
			return bp.tier
	push_error(name + " passive blueprint not found: " + bp_name)
	return -1


# Returns true if Morphose has the supplied blueprint or a predecessor, false otherwise
func hasBlueprintOrPredecessor(blueprint_in) -> bool:
	for bp in allBlueprints():
		if blueprint_in.equals(bp) or bp.isPredecessorOf(blueprint_in):
			return true
	return false
