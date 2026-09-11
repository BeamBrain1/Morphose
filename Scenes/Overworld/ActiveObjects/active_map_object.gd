class_name ActiveMapObject
extends AnimatedSprite2D

@export var is_solid: bool = false


# Override in children
func steppedOn() -> void:
	pass


# Override in children
func interactedWith() -> void:
	pass


func push(direction: GlobalProgramData.DIRECTION) -> void:
	setGridPosition(OverworldMap.gridPosition(self) + GlobalProgramData.direction_vector[direction])


func setGridPosition(grid_position: Vector2) -> void:
	position = OverworldMap.gridPositionToCanvasPosition(grid_position)
