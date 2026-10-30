extends Node


static var primus: PartyMember
static var defector: PartyMember
static var scholar: PartyMember


func _init() -> void:
	buildPartyMembers()


# Builds starting stats and base data of party members
static func buildPartyMembers() -> void:
	primus = PartyMember.new()
	primus.name = PartyMember.PARTY_MEMBER_PRIMUS_NAME
	primus.hp = PartyMember.HP_MINIMUM
	primus.tech_points = PartyMember.TP_MINIMUM
	primus.attack = PartyMember.STAT_MINIMUM
	primus.defense = PartyMember.STAT_MINIMUM
	primus.senses = PartyMember.STAT_MINIMUM
	primus.speed = PartyMember.STAT_MINIMUM
	primus.bio_energy = 0
	primus.discounted_stats = [Morphose.COMBAT_STAT.ATTACK, Morphose.COMBAT_STAT.SPEED, Morphose.COMBAT_STAT.SENSES]
	if GlobalProgramData.DEBUG_MODE:
		primus.hp = PartyMember.HP_CAP
		primus.tech_points = PartyMember.TP_CAP
		primus.attack = PartyMember.STAT_CAP
		primus.defense = PartyMember.STAT_CAP
		primus.senses = PartyMember.STAT_CAP
		primus.speed = PartyMember.STAT_CAP
		primus.blueprint_slots = PartyMember.MAX_BLUEPRINT_SLOTS
		primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("MegaCrush", 1), true)
		primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("Claw", 1), true)
		primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("Horn", 1), true)
		#primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("Laser", 1), true)
		primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("Auto Rifle", 1), true)
		primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("Honey", 1), true)
		primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("Acid Mist", 3), true)
		primus.installBlueprint(Blueprint.getBlueprintFromGlobalList("Overclock", 3), true)

	defector = PartyMember.new()
	defector.name = PartyMember.PARTY_MEMBER_DEFECTOR_NAME
	defector.hp = 25
	defector.tech_points = 15
	defector.attack = 6
	defector.defense = 8
	defector.senses = 5
	defector.speed = 5
	defector.bio_energy = 20
	defector.discounted_stats = [Morphose.COMBAT_STAT.HP, Morphose.COMBAT_STAT.ATTACK, Morphose.COMBAT_STAT.DEFENSE]
	defector.installBlueprint(Blueprint.getBlueprintFromGlobalList("Claw", 1), true)
	
	scholar = PartyMember.new()
	scholar.name = PartyMember.PARTY_MEMBER_SCHOLAR_NAME
	scholar.hp = 50
	scholar.tech_points = 40
	scholar.attack = 5
	scholar.defense = 12
	scholar.senses = 16
	scholar.speed = 12
	scholar.bio_energy = 0
	scholar.discounted_stats = [Morphose.COMBAT_STAT.HP, Morphose.COMBAT_STAT.TECH_POINTS, Morphose.COMBAT_STAT.SENSES]
	scholar.installBlueprint(Blueprint.getBlueprintFromGlobalList("Claw", 1), true)
	scholar.installBlueprint(Blueprint.getBlueprintFromGlobalList("Acid Spit", 1), true)
	scholar.installBlueprint(Blueprint.getBlueprintFromGlobalList("Honey", 1), true)
	scholar.installBlueprint(Blueprint.getBlueprintFromGlobalList("Whet", 1), true)


func getPartyMember(member_name: String) -> PartyMember:
	if member_name.matchn(PartyMember.PARTY_MEMBER_PRIMUS_NAME):
		return primus
	elif member_name.matchn(PartyMember.PARTY_MEMBER_DEFECTOR_NAME):
		return defector
	elif member_name.matchn(PartyMember.PARTY_MEMBER_SCHOLAR_NAME):
		return scholar
	push_error("Party member not found: " + member_name)
	return null
