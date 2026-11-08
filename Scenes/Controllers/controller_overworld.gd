class_name ControllerOverworld
extends Controller

const MAP_DIRECTORY = "res://Scenes/Overworld/Maps/"

var current_map: OverworldMap

@export var ScreenTransitioner: PackedScene
var current_transitioner = null

# Called to let a script paused (for warp or combat encounter) know that it can now resume execution
signal execute_script
signal resume_persistent_script


func _ready() -> void:
	$OverworldInputHandler.UI = $OverworldUI


func getCurrentMap() -> OverworldMap:
	return current_map


func openCharBuilderOutsideModStation() -> void:
	switchToCharBuildController(false)


func assignOverworldMapAndPartyLocation(map_name: String, party_grid_position: Vector2, party_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	if transitioningFromAnotherMap():		# If we're transitioning from another map, free its memory
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
	runMapOnLoadScriptIfPresent()


func loadSavedPartyLocation() -> void:
	loadInitialMap(ActiveSaveData.party.getCurrentMap(), ActiveSaveData.party.getCurrentGridPosition(), GlobalProgramData.DIRECTION.DOWN)


# Load a map when first switching to this controller
func loadInitialMap(map_name: String, party_grid_position: Vector2, party_direction: GlobalProgramData.DIRECTION) -> void:
	await assignOverworldMapAndPartyLocation(map_name, party_grid_position, party_direction)
	emit_signal("resume_persistent_script")
	runMapStartOfActionScriptIfPresent()


# Transition the party to a different map from the one they're currently on
func transitionToMap(destination: OverworldPosition) -> void:
	await startMapTransition()
	await assignOverworldMapAndPartyLocation(destination.map_name, destination.grid_position)
	await endMapTransition()
	emit_signal("resume_persistent_script")
	runMapStartOfActionScriptIfPresent()


func startMapTransition() -> void:
	$OverworldInputHandler.lockPlayerControls()
	current_transitioner = ScreenTransitioner.instantiate()
	add_child(current_transitioner)
	await current_transitioner.transitionClose()


func endMapTransition() -> void:
	move_child(current_transitioner, -1)	# Draw transitioner last so it covers screen
	await current_transitioner.transitionOpen()
	current_transitioner = null
	$OverworldInputHandler.unlockPlayerControls()


func blueprintCollected(blueprint) -> void:
	$OverworldUI.displayBlueprintCollectedDialog(blueprint)


func inputHandler() -> OverworldInputHandler:
	return $OverworldInputHandler


func overworldUI() -> OverworldUI:
	return $OverworldUI


func executeMapScript(script: MapScript) -> void:
	emit_signal("execute_script", script)


func runMapOnLoadScriptIfPresent() -> void:
	if current_map.hasOnLoadScript():
		call_deferred("emit_signal", "execute_script", current_map.getOnLoadScript())


func runMapStartOfActionScriptIfPresent() -> void:
	if current_map.hasStartOfActionScript():
		call_deferred("emit_signal", "execute_script", current_map.getStartOfActionScript())


func transitioningFromAnotherMap() -> bool:
	return current_transitioner != null
