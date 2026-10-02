class_name ActiveMapObject
extends AnimatedSprite2D

@export var is_solid: bool = false

const INTERACT_SCRIPT_NAME: String = "InteractScript"
const STEP_ON_SCRIPT_NAME: String = "StepOnScript"

var map_script: MapScript

signal request_script_execution

enum ACTIVATION_TYPE {STEP, INTERACT}
@export var activation_type: ACTIVATION_TYPE

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


func push(direction: GlobalProgramData.DIRECTION) -> void:
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
