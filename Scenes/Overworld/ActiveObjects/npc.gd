class_name NPC
extends ActiveMapObject

var interact_script: MapScript
var map: OverworldMap
@export var initial_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN
signal request_script_execution

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	faceDirection(initial_direction)
	if hasInteractScript():
		interact_script = get_node("InteractScript")


func attemptMove(direction: GlobalProgramData.DIRECTION) -> void:
	play(GlobalProgramData.direction_string[direction])
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + GlobalProgramData.direction_vector[direction]
	attemptMoveTo(move_destination)


func push(direction: GlobalProgramData.DIRECTION) -> void:
	attemptMove(direction)


func attemptMoveTo(destination_tile: Vector2):
	if map.tileIsTraversable(destination_tile):
		step(destination_tile)


func step(tile_grid_loc: Vector2) -> void:
	setGridPosition(tile_grid_loc)


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
