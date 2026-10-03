class_name WarpScript
extends MapScript


@export var destination_map: String
@export var destination_tile: Vector2


func body() -> void:
	await warpTo(destination_map, destination_tile)


func initialize(map_in: String, tile_in: Vector2) -> void:
	destination_map = map_in
	destination_tile = tile_in
