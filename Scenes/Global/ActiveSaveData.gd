extends Node

static var party_members: Array[PartyMember] = []
static var found_blueprints_attack: Array[BlueprintAttack] = []
static var found_blueprints_support: Array[BlueprintSupport] = []
static var found_blueprints_passive: Array[BlueprintPassive] = []
static var current_battle = 0


static func addPartyMember(party_member: PartyMember) -> void:
	party_members.append(party_member)


static func addBlueprint(blueprint) -> void:
	if blueprint is BlueprintAttack:
		found_blueprints_attack.append(blueprint)
	elif blueprint is BlueprintSupport:
		found_blueprints_support.append(blueprint)
	elif blueprint is BlueprintPassive:
		found_blueprints_passive.append(blueprint)


# Award Muta to all current party members
static func awardMuta(muta: int) -> void:
	for member in party_members:
		member.bio_energy += muta
