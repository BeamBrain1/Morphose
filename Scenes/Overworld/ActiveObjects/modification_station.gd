class_name ModificationStation
extends ActiveMapObject

signal used

func interact() -> void:
	emit_signal("used")
