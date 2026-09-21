class_name ControllerOverworld
extends Controller

const MAP_DIRECTORY = "res://Scenes/Overworld/Maps/"

var current_map: OverworldMap

# Called to let a script paused (for warp or combat encounter) know that it can now resume execution
signal execute_script


func _ready() -> void:
	$OverworldInputHandler.UI = $OverworldUI


func getCurrentMap() -> OverworldMap:
	return current_map


func openCharBuilderOutsideModStation() -> void:
	switchToCharBuildController(false)


func assignOverworldMapAndPartyLocation(map_name: String, party_grid_position: Vector2, party_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	if current_map != null:
		current_map.call_deferred("queue_free")
	current_map = load(MAP_DIRECTORY + map_name + ".tscn").instantiate()
	initializeCurrentMap(map_name, party_grid_position)
	$OverworldUI.move_to_front()
	$OverworldInputHandler.party_token = current_map.getPartyToken()


func initializeCurrentMap(map_name: String, party_grid_position: Vector2) -> void:
	add_child(current_map)
	$EncounterHandler.assignMap(current_map)
	current_map.request_script_execution.connect(executeMapScript)
	current_map.initialize(map_name, party_grid_position)


func loadSavedPartyLocation() -> void:
	assignOverworldMapAndPartyLocation(ActiveSaveData.party.getCurrentMap(), ActiveSaveData.party.getCurrentGridPosition())


func warpPartyTo(destination: OverworldPosition) -> void:
	assignOverworldMapAndPartyLocation(destination.map_name, destination.grid_position)


func blueprintCollected(blueprint) -> void:
	$OverworldUI.displayBlueprintCollectedDialog(blueprint)


func inputHandler() -> OverworldInputHandler:
	return $OverworldInputHandler


func overworldUI() -> OverworldUI:
	return $OverworldUI


func executeMapScript(script: MapScript) -> void:	
	emit_signal("execute_script", script)
