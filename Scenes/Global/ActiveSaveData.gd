extends Node

static var party: Party = Party.new()
static var found_blueprints_attack: Array[BlueprintAttack] = []
static var found_blueprints_support: Array[BlueprintSupport] = []
static var found_blueprints_passive: Array[BlueprintPassive] = []
static var current_battle = 0


static func getNextBattle() -> Array:
	return EncounterTable.getEncounterAtIndex(current_battle)


static func collectBlueprint(blueprint) -> void:
	if blueprint is BlueprintAttack:
		found_blueprints_attack.append(blueprint)
	elif blueprint is BlueprintSupport:
		found_blueprints_support.append(blueprint)
	if blueprint is BlueprintPassive:
		found_blueprints_passive.append(blueprint)


static func allCollectedBlueprints() -> Array:
	var result = []
	for list in [found_blueprints_attack, found_blueprints_support, found_blueprints_passive]:
		for blueprint in list:
			result.append(blueprint)
	return result
