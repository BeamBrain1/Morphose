class_name WarpPoint
extends ActiveMapObject


@export var destination_map: String
@export var destination_tile: Vector2

var destination: OverworldPosition

signal warp

func _ready() -> void:
	hide()
	destination = OverworldPosition.new(destination_map, destination_tile)


func steppedOn() -> void:
	emit_signal("warp", destination)
