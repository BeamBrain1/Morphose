class_name Blueprint

const NUM_NAME_CHARS: int = 10			# Pad name to this size, including generation

var base_display_name: String = "[NO DATA]"
var override_display_name: String = ""

var tier: int = 1						# Higher tiers are stronger versions of same abilities
										# Higher tiers of attack/passive abilities also give access
										#	to their lower-tier versions
var bio_cost_track: String = "X"			# Track for how much bio-energy a Morphose must spend to install


var primus_compatible: bool = false		# Determines whether each party member can install it
var defector_compatible: bool = false
var scholar_compatible: bool = false

var tp_cost_track: String = "X"			# Track for tech point cost per use
var multitarget: bool = false	# If true, affects all eligible targets
var predecessors: Array = []	# List of predecessor blueprints: lower-tier bluepritns of same name
var special: String = ""		# Used to assign additional one-off capabilities

const BIO_COST_T2_MULT: int = 16
const BIO_COST_T2_MULT_Q_TRACK: int = 6
const BIO_COST_T2_MULT_STATUS: int = 16
const BIO_COST_T3_MULT: int = BIO_COST_T2_MULT * 6
const BIO_COST_T3_MULT_STATUS: int = BIO_COST_T2_MULT_STATUS * 6
const TP_COST_T2_MULT: int = 5
const TP_COST_T2_MULT_STATUS: int = 5
const TP_COST_T3_MULT: int = TP_COST_T2_MULT * 3
const TP_COST_T3_MULT_STATUS: int = TP_COST_T2_MULT_STATUS * 3


# Blueprints are organized into bio cost "tracks." Individual blueprint cost is determined by track letter and tier.
const BIO_COST_TRACKS: Dictionary = {
	"X": 0,
	"A": 20,
	"B": 30,
	"C": 40,
	"D": 50,
	"E": 60,
	"Q": 1000,
	"Z": 9999
}

# Determines how much TP it costs to use a given blueprint
const TP_COST_TRACKS: Dictionary = {
	"X": 0,
	"A": 3,
	"B": 5,
	"C": 8,
	"D": 10,
	"E": 16,
	"F": 20,
	"G": 22,
	"Z1": 30,
	"Z2": 600
}

func getDialogDisplayName() -> String:
	if override_display_name != "":
		return override_display_name
	if tier == 1:
		return base_display_name
	return base_display_name + " " + str(tier)


func getMenuDisplayName() -> String:
	if override_display_name != "":
		return " " + override_display_name.rpad(NUM_NAME_CHARS)
	if tier == 1:
		return " " + base_display_name.rpad(NUM_NAME_CHARS)
	return " " + base_display_name.rpad(NUM_NAME_CHARS - 1) + str(tier)


func equals(other: Blueprint) -> bool:
	return base_display_name.matchn(other.base_display_name) and tier == other.tier


func isPredecessorOf(other) -> bool:
	return base_display_name.matchn(other.base_display_name) and tier < other.tier


func isPredecessorOrSuccessorOf(other) -> bool:
	return base_display_name.matchn(other.base_display_name) and tier != other.tier


func hasPredecessors() -> bool:
	return not predecessors.is_empty()


# Build a list of this blueprint's predecessors
func buildPredecessorList(blueprint_list: Array) -> void:
	predecessors = []
	for blueprint in blueprint_list:
		if blueprint.isPredecessorOf(self):
			predecessors.append(blueprint)


func sufficientTPForAtLeastOnePredecessor(tp: int) -> bool:
	for bp in predecessors:
		if bp.getTechPointCost() <= tp:
			return true
	return false


# Given a blueprint name and a tier, pull blueprint from supplied list
# If no tier-in supplied, get first that matches name
static func getBlueprintFromList(blueprint_list: Array, name_in: String, tier_in: int = 0):
	
	for blueprint in blueprint_list:
		if blueprint.base_display_name.matchn(name_in) and blueprint.tier == tier_in:
			return blueprint
		elif blueprint.base_display_name.matchn(name_in) and tier_in == 0:
			return blueprint
	
	push_error("Blueprint not found: " + getDialogDisplayNameFromParameters(name_in, tier_in))
	return null


static func blueprintIsInList(blueprint_list: Array, name_in: String, tier_in: int = 1):
	for blueprint in blueprint_list:
		if blueprint.base_display_name.matchn(name_in) and blueprint.tier == tier_in:
			return true
	return false


func isInList(blueprint_list: Array):
	for blueprint in blueprint_list:
		if equals(blueprint):
			return true
	return false


static func getBlueprintFromGlobalList(name_in: String, tier_in: int) -> Blueprint:
	return getBlueprintFromList(GlobalProgramData.all_blueprints, name_in, tier_in)


static func getDialogDisplayNameFromParameters(name_in: String, tier_in: int) -> String:
	return getBlueprintFromGlobalList(name_in, tier_in).getDialogDisplayName()


static func sortBlueprintsAscendingBattle(a: Blueprint, b: Blueprint):
	return sortBlueprintsAscendingCharBuild(a, b)


static func sortBlueprintsAscendingCharBuild(a: Blueprint, b: Blueprint):
	if a.base_display_name < b.base_display_name:
		return true
	elif a.base_display_name == b.base_display_name:
		return a.tier < b.tier
	return false


static func sortBlueprintsDescending(a: Blueprint, b: Blueprint):
	if a.base_display_name > b.base_display_name:
		return true
	elif a.base_display_name == b.base_display_name:
		return a.tier > b.tier
	return false


func getBioEnergyCost() -> int:
	var result = BIO_COST_TRACKS[bio_cost_track.to_upper()]
	if tier == 2:
		if isSupportStatusEffectBlueprint():
			result *= BIO_COST_T2_MULT_STATUS
		elif isStatusEffectBlueprint():
			result *= BIO_COST_T2_MULT_STATUS
		elif bio_cost_track == "Q":
			result *= BIO_COST_T2_MULT_Q_TRACK
		else:
			result *= BIO_COST_T2_MULT
	elif tier >= 3:
		if isSupportStatusEffectBlueprint():
			result *= BIO_COST_T3_MULT_STATUS
		elif isStatusEffectBlueprint():
			result *= BIO_COST_T3_MULT_STATUS
		else:
			result *= BIO_COST_T3_MULT
	return result


func getTechPointCost() -> int:
	var result = TP_COST_TRACKS[tp_cost_track.to_upper()]
	if tier == 2:
		if isStatusEffectBlueprint():
			result *= TP_COST_T2_MULT_STATUS
		else:
			result *= TP_COST_T2_MULT
	elif tier >= 3:
		if isStatusEffectBlueprint():
			result *= TP_COST_T3_MULT_STATUS
		else:
			result *= TP_COST_T3_MULT
	return result


func isZenithBlueprint() -> bool:
	return bio_cost_track.matchn("Z")


# Override in children
func isStatusEffectBlueprint() -> bool:
	return false


# Override in children
func isSupportStatusEffectBlueprint() -> bool:
	return false
