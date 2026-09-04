extends Node

static var party: Party = Party.new()
static var found_blueprints_attack: Array[BlueprintAttack] = []
static var found_blueprints_support: Array[BlueprintSupport] = []
static var found_blueprints_passive: Array[BlueprintPassive] = []


static func collectBlueprint(blueprint) -> void:
	party.collectBlueprint(blueprint)


static func allCollectedBlueprints() -> Array:
	return party.allCollectedBlueprints()


static func getPartyMemberByName(name_in: String) -> PartyMember:
	return party.getPartyMemberByName(name_in)
