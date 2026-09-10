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
	position = OverworldMap.gridPositionToCanvasPosition(OverworldMap.gridPosition(self) + GlobalProgramData.direction_vector[direction])
