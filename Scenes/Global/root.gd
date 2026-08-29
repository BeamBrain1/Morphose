extends Node2D

var active_controller

const CONTROLLER_DIRECTORY_AND_PREFIX = "res://Scenes/Controllers/Controller"

const STARTING_BIO_ENERGY: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.content_scale_size = Vector2(960, 720)
	randomize()
	loadStartingPartyMembers()
	loadBlueprints()
	setActiveController("BuildCharacter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setActiveController(controller: String) -> void:
	if active_controller != null:
		active_controller.call_deferred("queue_free")
	active_controller = load(CONTROLLER_DIRECTORY_AND_PREFIX + controller + ".tscn").instantiate()
	active_controller.root = self
	add_child(active_controller)


# won_previous: Did we win a previous battle? Used to determine whether to add a new party member
#	(a party member only gets added the first time we prep for a specific battle number
func toCharacterBuildScreen(won_previous = false) -> void:
	if won_previous:
		ActiveSaveData.current_battle += 1
		if ActiveSaveData.current_battle == GlobalProgramData.ADD_DEFECTOR_BEFORE_BATTLE:
			addDefector()
		if ActiveSaveData.current_battle == GlobalProgramData.ADD_SCHOLAR_BEFORE_BATTLE:
			addScholar()

	setActiveController("BuildCharacter")


func skipBattle() -> void:
	var base_muta_value : int = EncounterTable.getEncounterBioEnergyValue(ActiveSaveData.current_battle)
	ActiveSaveData.party.awardMuta(ceili(float(base_muta_value) / ActiveSaveData.party.members.size()))
	toCharacterBuildScreen(true)


func skipToEncounter() -> void:
	while not EncounterTable.encounterHasEnemy(EncounterTable.table[ActiveSaveData.current_battle], "Silo Lord"):
		skipBattle()


func loadStartingPartyMembers() -> void:
	var c1: PartyMember = PartyMember.new()
	c1.name = PartyMember.PARTY_MEMBER_1_NAME
	c1.hp = PartyMember.HP_MINIMUM
	c1.tech_points = PartyMember.TP_MINIMUM
	c1.attack = PartyMember.STAT_MINIMUM
	c1.defense = PartyMember.STAT_MINIMUM
	c1.senses = PartyMember.STAT_MINIMUM
	c1.speed = PartyMember.STAT_MINIMUM
	c1.bio_energy = STARTING_BIO_ENERGY
	c1.discounted_stats = [GlobalProgramData.COMBAT_STAT.ATTACK, GlobalProgramData.COMBAT_STAT.SPEED, GlobalProgramData.COMBAT_STAT.SENSES]
	
	c1.installBlueprint(Blueprint.getBlueprintFromGlobalList("Claw", 1), true)
	
	ActiveSaveData.party.addPartyMember(c1)


func addDefector():
	var c2: PartyMember = PartyMember.new()
	c2.name = PartyMember.PARTY_MEMBER_2_NAME
	c2.hp = 25
	c2.tech_points = 15
	c2.attack = 5
	c2.defense = 8
	c2.senses = 6
	c2.speed = 6
	c2.bio_energy = 20
	c2.discounted_stats = [GlobalProgramData.COMBAT_STAT.HP, GlobalProgramData.COMBAT_STAT.ATTACK, GlobalProgramData.COMBAT_STAT.DEFENSE]

	c2.installBlueprint(Blueprint.getBlueprintFromGlobalList("Claw", 1), true)
	
	ActiveSaveData.party.addPartyMember(c2)


func addScholar():
	var c3: PartyMember = PartyMember.new()
	c3.name = PartyMember.PARTY_MEMBER_3_NAME
	c3.hp = 50
	c3.tech_points = 40
	c3.attack = 5
	c3.defense = 12
	c3.senses = 16
	c3.speed = 12
	c3.bio_energy = 0
	c3.discounted_stats = [GlobalProgramData.COMBAT_STAT.HP, GlobalProgramData.COMBAT_STAT.TECH_POINTS, GlobalProgramData.COMBAT_STAT.SENSES]

	c3.installBlueprint(Blueprint.getBlueprintFromGlobalList("Claw", 1), true)
	c3.installBlueprint(Blueprint.getBlueprintFromGlobalList("Acid Spit", 1), true)
	c3.installBlueprint(Blueprint.getBlueprintFromGlobalList("Honey", 1), true)
	c3.installBlueprint(Blueprint.getBlueprintFromGlobalList("Whet", 1), true)
	ActiveSaveData.party.addPartyMember(c3)


func loadBlueprints() -> void:
	for blueprint in GlobalProgramData.all_blueprints:
		if blueprint is BlueprintAttack:
			ActiveSaveData.party.found_blueprints_attack.append(blueprint)
		elif blueprint is BlueprintSupport:
			ActiveSaveData.party.found_blueprints_support.append(blueprint)
		elif blueprint is BlueprintPassive:
			ActiveSaveData.party.found_blueprints_passive.append(blueprint)
