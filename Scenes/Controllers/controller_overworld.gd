class_name ControllerOverworld
extends Controller

const MAP_DIRECTORY = "res://Scenes/Overworld/Maps/"

var current_map: OverworldMap

var danger_level: int = 0
const ENCOUNTER_RATE: int = 10
const ENCOUNTER_THRESHOLD: int = 100


func assignOverworldMapAndPartyLocation(map_name: String, party_grid_position: Vector2, party_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	if current_map != null:
		current_map.call_deferred("queue_free")
	current_map = load(MAP_DIRECTORY + map_name + ".tscn").instantiate()
	add_child(current_map)
	current_map.party_moved.connect(partyStep)
	current_map.warp_point_hit.connect(warpPartyTo)
	current_map.setPartyGridPosition(party_grid_position)
	current_map.map_name = map_name
	updateGlobalPartyPosition()


func partyStep() -> void:
	updateGlobalPartyPosition()
	danger_level += 1 + randi() % ENCOUNTER_RATE
	if danger_level >= ENCOUNTER_THRESHOLD:
		doEncounter()


func doEncounter() -> void:
	danger_level = 0
	print("Encounter")


func updateGlobalPartyPosition() -> void:
	var party_token: PartyToken = current_map.getPartyToken()
	var overworld_position: OverworldPosition = OverworldPosition.new(current_map.map_name, OverworldMap.gridPosition(party_token))
	ActiveSaveData.party.setLocationAndDirection(overworld_position, party_token.currentFacingDirection())


func warpPartyTo(warp_point: WarpPoint) -> void:
	assignOverworldMapAndPartyLocation(warp_point.destination_map, warp_point.destination_tile)
