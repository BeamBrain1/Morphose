class_name ActiveMapObject
extends AnimatedSprite2D

@export var is_solid: bool = false

const INTERACT_SCRIPT_NAME: String = "InteractScript"
const STEP_ON_SCRIPT_NAME: String = "StepOnScript"

var map_script: MapScript

signal request_script_execution
signal stepped

var is_moving: bool = false
var current_travel_vector: Vector2i
var move_to_tile: Vector2i
var distance_moved_this_push: int = 0

const MOVE_RATE: int = 1	# Pixels per tick moved when moving between tiles

enum ACTIVATION_TYPE {STEP, INTERACT}
@export var activation_type: ACTIVATION_TYPE

# Additional tiles the map object occupies other than itself, relative to its own position
@export var ADDITIONAL_OCCUPIED_TILES: Array[Vector2i]

func _ready() -> void:
	for node in get_children():
		if node is MapScript:
			map_script = node
			break


func _process(delta) -> void:
	if is_moving:
		moveTick()
		# If we are at or past our destination, we've arrived
		if distance_moved_this_push >= OverworldMap.TILE_SIZE:
			arriveAtDestination()


func steppedOn() -> void:
	if activation_type == ACTIVATION_TYPE.STEP and map_script != null:
		emit_signal("request_script_execution", map_script)


func interactedWith() -> void:
	if activation_type == ACTIVATION_TYPE.INTERACT and map_script != null:
		emit_signal("request_script_execution", map_script)


func push(direction: GlobalProgramData.DIRECTION, change_direction: bool = true) -> void:
	if not is_moving:
		current_travel_vector = GlobalProgramData.direction_vector[direction]
		move_to_tile = OverworldMap.gridPosition(self) + current_travel_vector
		distance_moved_this_push = 0
		is_moving = true


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


func moveTick() -> void:
	position += Vector2(current_travel_vector * MOVE_RATE)
	distance_moved_this_push += MOVE_RATE


func arriveAtDestination() -> void:
	setGridPosition(move_to_tile)
	is_moving = false
	emit_signal("stepped")
