class_name ModificationStation
extends ActiveMapObject

signal used

func interactedWith() -> void:
	emit_signal("used")
