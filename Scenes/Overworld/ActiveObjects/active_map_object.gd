class_name ActiveMapObject
extends AnimatedSprite2D

@export var is_solid: bool = false


# Override in children
func steppedOn() -> void:
	pass


# Override in children
func interact() -> void:
	pass
