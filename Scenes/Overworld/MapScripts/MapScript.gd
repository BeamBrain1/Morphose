class_name MapScript
extends Node

var controller: ControllerOverworld


func attachController(controller_in: ControllerOverworld) -> void:
	controller = controller_in


func execute() -> void:
	controller.inputHandler().lockPlayerControls()
	await body()
	controller.inputHandler().unlockPlayerControls()


# Override in derived class
func body() -> void:
	push_error("Script undefined: " + name)


func displayDialog(speaker: String, dialog: String) -> void:
	controller.overworldUI().displayDialog(speaker, dialog)
	await controller.overworldUI().closed_dialog


# Introduce a delay of the specified time into the script
func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func pushParty(num_tiles: int, direction: GlobalProgramData.DIRECTION, step_delay: float = 0.1) -> void:
	await pushActor(controller.current_map.getPartyToken(), num_tiles, direction, step_delay)


func pushActiveObject(name_in: String, num_tiles: int, direction: GlobalProgramData.DIRECTION, step_delay: float = 0.1):
	await pushActor(controller.getCurrentMap().getActiveObjectByName(name_in), num_tiles, direction, step_delay)


func pushActor(actor: ActiveMapObject, num_tiles: int, direction: GlobalProgramData.DIRECTION, step_delay: float = 0.1) -> void:
	for i in range(num_tiles):
		actor.push(direction)
		await delay(step_delay)


func globalFlags() -> OverworldFlags:
	return ActiveSaveData.overworld_flags


func spawnActiveObject(scene_name: String, node_name: String, grid_position: Vector2) -> void:
	controller.getCurrentMap().spawnActiveObject(scene_name, node_name, grid_position)


func destroyActiveObject(node_name: String) -> void:
	controller.getCurrentMap().destroyActiveObject(node_name)


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
