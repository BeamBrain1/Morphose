class_name ControllerOverworld
extends Controller

const MAP_DIRECTORY = "res://Scenes/Overworld/Maps/"

var current_map: OverworldMap

var danger_level: int = 0
const ENCOUNTER_RATE: int = 10
const ENCOUNTER_THRESHOLD: int = 100


func _process(delta) -> void:
	if Input.is_action_just_pressed("pause"):
		switchToCharBuildController(false)


func assignOverworldMapAndPartyLocation(map_name: String, party_grid_position: Vector2, party_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	if current_map != null:
		current_map.call_deferred("queue_free")
	current_map = load(MAP_DIRECTORY + map_name + ".tscn").instantiate()
	add_child(current_map)
	current_map.party_moved.connect(partyStep)
	current_map.warp_point_hit.connect(warpPartyTo)
	current_map.bp_collected.connect(collectBlueprint)
	current_map.mod_station_activated.connect(switchToCharBuildController, true)
	current_map.setPartyGridPosition(party_grid_position)
	current_map.map_name = map_name
	updateGlobalPartyPosition()


func loadSavedPartyLocation() -> void:
	assignOverworldMapAndPartyLocation(ActiveSaveData.party.getCurrentMap(), ActiveSaveData.party.getCurrentGridPosition())


func partyStep() -> void:
	updateGlobalPartyPosition()
	if current_map.partyEncounterZone() != null:
		danger_level += 1 + randi() % ENCOUNTER_RATE
		if danger_level >= ENCOUNTER_THRESHOLD:
			doEncounter()


func doEncounter() -> void:
	danger_level = 0
	var encounter = current_map.partyEncounterZone().getRandomEncounter()
	switchToBattleController(encounter)


func updateGlobalPartyPosition() -> void:
	var party_token: PartyToken = current_map.getPartyToken()
	var overworld_position: OverworldPosition = OverworldPosition.new(current_map.map_name, OverworldMap.gridPosition(party_token))
	ActiveSaveData.party.setLocationAndDirection(overworld_position, party_token.currentFacingDirection())


func warpPartyTo(warp_point: WarpPoint) -> void:
	assignOverworldMapAndPartyLocation(warp_point.destination_map, warp_point.destination_tile)


func collectBlueprint(blueprint) -> void:
	ActiveSaveData.collectBlueprint(blueprint)
	print("Collected blueprint: " + blueprint.getDialogDisplayName())
