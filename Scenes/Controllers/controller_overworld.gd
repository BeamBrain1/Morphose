class_name ControllerOverworld
extends Controller

const MAP_DIRECTORY = "res://Scenes/Overworld/Maps/"

var current_map: OverworldMap


func _ready() -> void:
	$InputHandler.UI = $OverworldUI


func openCharBuilderOutsideModStation() -> void:
	switchToCharBuildController(false)


func assignOverworldMapAndPartyLocation(map_name: String, party_grid_position: Vector2, party_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	if current_map != null:
		current_map.call_deferred("queue_free")
	current_map = load(MAP_DIRECTORY + map_name + ".tscn").instantiate()
	initializeCurrentMap(map_name, party_grid_position)
	$OverworldUI.move_to_front()
	$InputHandler.party_token = current_map.getPartyToken()


func initializeCurrentMap(map_name: String, party_grid_position: Vector2) -> void:
	add_child(current_map)
	$EncounterHandler.assignMap(current_map)
	current_map.warp_point_hit.connect(warpPartyTo)
	current_map.blueprint_collected.connect(blueprintCollected)
	current_map.mod_station_activated.connect(switchToCharBuildController, true)
	current_map.initialize(map_name, party_grid_position)


func loadSavedPartyLocation() -> void:
	assignOverworldMapAndPartyLocation(ActiveSaveData.party.getCurrentMap(), ActiveSaveData.party.getCurrentGridPosition())


func warpPartyTo(destination: OverworldPosition) -> void:
	assignOverworldMapAndPartyLocation(destination.map_name, destination.grid_position)


func blueprintCollected(blueprint) -> void:
	$OverworldUI.displayBlueprintCollectedDialog(blueprint)
