class_name MapScript
extends Node

var handler: ScriptHandler

signal resume_execution

func attachHandler(handler_in: ScriptHandler) -> void:
	handler = handler_in


func execute() -> void:
	inputHandler().lockPlayerControls()
	await body()
	inputHandler().unlockPlayerControls()
	handler.clearScript()


func controllerOverworld() -> ControllerOverworld:
	return handler.controllerOverworld()


func inputHandler() -> OverworldInputHandler:
	return controllerOverworld().inputHandler()


func overworldUI() -> OverworldUI:
	return controllerOverworld().overworldUI()


func activeMap() -> OverworldMap:
	return controllerOverworld().current_map


# Override in derived class
func body() -> void:
	push_error("Script undefined: " + name)


func displayDialog(speaker: String, dialog: String) -> void:
	overworldUI().displayDialog(speaker, dialog)
	await overworldUI().closed_dialog


# Introduce a delay of the specified time into the script
func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func pushParty(num_tiles: int, direction: GlobalProgramData.DIRECTION, step_delay: float = 0.1) -> void:
	await pushActor(activeMap().getPartyToken(), num_tiles, direction, step_delay)


func pushActiveObject(name_in: String, num_tiles: int, direction: GlobalProgramData.DIRECTION, step_delay: float = 0.1):
	await pushActor(activeMap().getActiveObjectByName(name_in), num_tiles, direction, step_delay)


func pushActor(actor: ActiveMapObject, num_tiles: int, direction: GlobalProgramData.DIRECTION, step_delay: float = 0.1) -> void:
	for i in range(num_tiles):
		actor.push(direction)
		await delay(step_delay)


func globalFlags() -> OverworldFlags:
	return ActiveSaveData.overworld_flags


func spawnActiveObject(scene_name: String, node_name: String, grid_position: Vector2) -> void:
	activeMap().spawnActiveObject(scene_name, node_name, grid_position)


func destroyActiveObject(node_name: String) -> void:
	activeMap().destroyActiveObject(node_name)


# Returns flag value for key, or default value if flag not present
func getFlagIntValue(flag: String) -> int:
	return globalFlags().getIntValue(flag)


func setFlagIntValue(flag: String, value: int) -> void:
	globalFlags().setFlagIntValue(flag, value)


# A nonzero value is treated as set; 0 is not set
func isFlagSet(flag: String) -> bool:
	return globalFlags().isFlagSet(flag)


func setFlag(flag: String) -> void:
	globalFlags().setFlag(flag)


func clearFlag(flag: String) -> void:
	globalFlags().clearFlag(flag)


# Add int to flag. If flag not present, push an error
func addTo(flag: String, value: int) -> void:
	globalFlags().addTo(flag, value)


# Sub int from flag. If flag not present, push an error
func subFrom(flag: String, value: int) -> void:
	globalFlags().subFrom(flag, value)


# Changes map tile in specified layer and position to specified cell in tile atlas
func setMapTile(layer: String, grid_position: Vector2, atlas_offset: Vector2) -> void:
	activeMap().setMapTile(layer, grid_position, atlas_offset)


func warpTo(map_name: String, grid_position: Vector2) -> void:
	await controllerOverworld().warpPartyTo(OverworldPosition.new(map_name, grid_position))


func doEncounter(enemy_list: Array[String]) -> void:
	controllerOverworld().switchToBattleController(EnemyTable.buildEnemyList(enemy_list))
	await resume_execution		# Encounters take us out of the overworld, so pause the script


func resumeExecution() -> void:
	emit_signal("resume_execution")
