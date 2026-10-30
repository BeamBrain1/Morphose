class_name ActiveMapObject
extends AnimatedSprite2D

@export var is_solid: bool = false

const INTERACT_SCRIPT_NAME: String = "InteractScript"
const STEP_ON_SCRIPT_NAME: String = "StepOnScript"

var map_script: MapScript

signal request_script_execution

enum ACTIVATION_TYPE {STEP, INTERACT}
@export var activation_type: ACTIVATION_TYPE

# Additional tiles the map object occupies other than itself, relative to its own position
@export var ADDITIONAL_OCCUPIED_TILES: Array[Vector2i]

func _ready() -> void:
	for node in get_children():
		if node is MapScript:
			map_script = node
			break


func steppedOn() -> void:
	if activation_type == ACTIVATION_TYPE.STEP and map_script != null:
		emit_signal("request_script_execution", map_script)


func interactedWith() -> void:
	if activation_type == ACTIVATION_TYPE.INTERACT and map_script != null:
		emit_signal("request_script_execution", map_script)


func push(direction: GlobalProgramData.DIRECTION, change_direction: bool = true) -> void:
	setGridPosition(OverworldMap.gridPosition(self) + GlobalProgramData.direction_vector[direction])


func setGridPosition(grid_position: Vector2) -> void:
	position = OverworldMap.gridPositionToCanvasPosition(grid_position)


func hasScript() -> bool:
	for node in get_children():
		if node is MapScript:
			return true
	return false


func getScript() -> MapScript:
	for node in get_children():
		if node is MapScript:
			return node
	push_error("ActiveMapObject tried to get script but has none: " + name)
	return null


# Tiles this map object occupies, including its origin
# grid_position: The object's current position in its occupied grid
func occupiedTiles(grid_position: Vector2i) -> Array:
	var result = [grid_position]
	for tile_offset in ADDITIONAL_OCCUPIED_TILES:
		result.append(grid_position + tile_offset)
	return result
