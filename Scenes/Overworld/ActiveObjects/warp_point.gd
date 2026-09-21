class_name WarpPoint
extends ActiveMapObject


@export var destination_map: String
@export var destination_tile: Vector2

var destination: OverworldPosition

func _ready() -> void:
	super()
	hide()
	destination = OverworldPosition.new(destination_map, destination_tile)
	initializeWarpScript()


func initializeWarpScript() -> void:
	map_script.initialize(destination_map, destination_tile)
