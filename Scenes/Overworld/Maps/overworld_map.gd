class_name OverworldMap
extends Node2D

const TILE_SIZE: int = 16

signal party_moved
var map_name: String


func _ready() -> void:
	get_node("PartyToken").move.connect(attemptMovePartyToken)


func setPartyGridPosition(tile_grid_loc: Vector2) -> void:
	$PartyToken.position = gridPositionToCanvasPosition(tile_grid_loc)
	position = centerTileOnScreenLocation() - $PartyToken.position


func tileIsTraversable(tile_loc: Vector2) -> bool:
	for tile_map in get_node("TileMapLayersLower").get_children():
		if tile_map.isSolidTile(tile_loc):
			return false
	for tile_map in get_node("TileMapLayersUpper").get_children():
		if tile_map.isSolidTile(tile_loc):
			return false
	return true


func getPartyToken() -> PartyToken:
	return $PartyToken


# Attempt to move the party token. Returns true if successful movement, false if location blocked
func attemptMovePartyToken(direction: GlobalProgramData.DIRECTION) -> bool:
	
	var destination_tile: Vector2 = gridPosition($PartyToken) + GlobalProgramData.direction_vector[direction]
	
	if tileIsTraversable(destination_tile):
		setPartyGridPosition(destination_tile)
		emit_signal("party_moved")
		return true
	return false


static func gridPosition(object) -> Vector2:
	return object.position / TILE_SIZE


static func gridPositionToCanvasPosition(grid_position: Vector2) -> Vector2:
	return grid_position * TILE_SIZE


static func centerTileOnScreenLocation() -> Vector2:
	var result: Vector2 = GlobalProgramData.NATIVE_RESOLUTION / TILE_SIZE / 2
	result = Vector2(floori(result.x), floori(result.y))
	return gridPositionToCanvasPosition(result)
