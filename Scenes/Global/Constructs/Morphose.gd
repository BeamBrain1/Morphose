class_name Morphose

const HP_CAP: int = 999
const HP_MINIMUM: int = 10
const TP_MINIMUM: int = 5
const TP_CAP: int = 999
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
