class_name Blueprint

const NUM_NAME_CHARS: int = 10			# Pad name to this size, including generation

var base_display_name: String = "[NO DATA]"
var tier: int = 1						# Higher tiers are stronger versions of same abilities
										# Higher tiers of attack/passive abilities also give access
										#	to their lower-tier versions
var bio_energy_cost: int = 0			# How much bio-energy a Morphose must spend to install

var primus_compatible: bool = false		# Determines whether each party member can install it
var defector_compatible: bool = false
var scholar_compatible: bool = false

var tp_cost: int = 0			# tech point cost per use
var multitarget: bool = false	# If true, affects all eligible targets
var predecessors: Array = []	# List of predecessor blueprints: lower-tier bluepritns of same name
var special: String = ""		# Used to assign additional one-off capabilities


func getDialogDisplayName() -> String:
	if tier == 1:
		return base_display_name
	return base_display_name + " " + str(tier)


func getMenuDisplayName() -> String:
	if tier == 1:
		return " " + base_display_name.rpad(NUM_NAME_CHARS)
	return " " + base_display_name.rpad(NUM_NAME_CHARS - 1) + str(tier)


func equals(other: Blueprint) -> bool:
	return base_display_name == other.base_display_name and tier == other.tier


func isPredecessorOf(other) -> bool:
	return base_display_name == other.base_display_name and tier < other.tier


func isPredecessorOrSuccessorOf(other) -> bool:
	return base_display_name == other.base_display_name and tier != other.tier


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
		if bp.tp_cost <= tp:
			return true
	return false


# Given a blueprint name and a tier, pull blueprint from supplied list
static func getBlueprintFromList(blueprint_list: Array, name_in: String, tier_in: int = 1):
	
	for blueprint in blueprint_list:
		if blueprint.base_display_name.matchn(name_in) and blueprint.tier == tier_in:
			return blueprint
	
	push_error("Blueprint not found: " + getDialogDisplayNameFromParameters(name_in, tier_in))
	return null


func isInList(blueprint_list: Array):
	for blueprint in blueprint_list:
		if base_display_name.to_upper() == blueprint.base_display_name.to_upper() and tier == blueprint.tier:
			return true
	return false


static func getBlueprintFromGlobalList(name_in: String, tier_in: int):
	return getBlueprintFromList(GlobalProgramData.all_blueprints, name_in, tier_in)


static func getDialogDisplayNameFromParameters(name_in: String, tier_in: int) -> String:
	if tier_in == 1:
		return name_in
	return name_in + " " + str(tier_in)


static func sortBlueprintsAscending(a, b):
	if a.base_display_name < b.base_display_name:
		return true
	elif a.base_display_name == b.base_display_name:
		return a.tier < b.tier
	return false


static func sortBlueprintsDescending(a, b):
	if a.base_display_name > b.base_display_name:
		return true
	elif a.base_display_name == b.base_display_name:
		return a.tier > b.tier
	return false
