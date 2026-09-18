class_name NPC
extends ActiveMapObject

var interact_script: MapScript
var map: OverworldMap
signal request_script_execution

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hasInteractScript():
		interact_script = get_node("InteractScript")


func attemptMoveUp(scripted: bool = false) -> void:
	play("up")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.UP
	attemptMoveTo(move_destination)


func attemptMoveDown(scripted: bool = false) -> void:
	play("down")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.DOWN
	attemptMoveTo(move_destination)


func attemptMoveLeft(scripted: bool = false) -> void:
	play("left")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.LEFT
	attemptMoveTo(move_destination)


func attemptMoveRight(scripted: bool = false) -> void:
	play("right")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.RIGHT
	attemptMoveTo(move_destination)


func attemptMoveTo(destination_tile: Vector2):
	if map.tileIsTraversable(destination_tile):
		step(destination_tile)


func step(tile_grid_loc: Vector2) -> void:
	setGridPosition(tile_grid_loc)


func hasIdleScript() -> bool:
	return has_node("IdleScript") and get_node("IdleScript") is MapScript


func hasInteractScript() -> bool:
	return has_node("InteractScript") and get_node("InteractScript") is MapScript


# Overrides parent
func interactedWith() -> void:
	if hasInteractScript():
		requestScriptExecution()


func requestScriptExecution() -> void:
	emit_signal("request_script_execution", interact_script)


func faceDirection(direction: GlobalProgramData.DIRECTION) -> void:
	play(GlobalProgramData.direction_string[direction])


func assignMap(map_in: OverworldMap) -> void:
	map = map_in
