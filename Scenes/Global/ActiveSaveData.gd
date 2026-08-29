extends Node

static var party: Party = Party.new()
static var found_blueprints_attack: Array[BlueprintAttack] = []
static var found_blueprints_support: Array[BlueprintSupport] = []
static var found_blueprints_passive: Array[BlueprintPassive] = []
static var current_battle = 0


static func getNextBattle() -> Array:
	return EncounterTable.getEncounterAtIndex(current_battle)
