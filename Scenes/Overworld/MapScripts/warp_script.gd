extends MapScript


var destination_map: String
var destination_tile: Vector2


func body() -> void:
	await warpTo(destination_map, destination_tile)


func initialize(map_in: String, tile_in: Vector2) -> void:
	destination_map = map_in
	destination_tile = tile_in
