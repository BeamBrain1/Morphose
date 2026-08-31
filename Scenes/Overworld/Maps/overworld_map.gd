class_name OverworldMap
extends Node2D

const TILE_SIZE: int = 16

signal party_moved
signal warp_point_hit

var map_name: String


func _ready() -> void:
	get_node("PartyToken").move.connect(attemptMovePartyToken)


func setPartyGridPosition(tile_grid_loc: Vector2) -> void:
	$PartyToken.position = gridPositionToCanvasPosition(tile_grid_loc)
	position = centerTileOnScreenLocation() - $PartyToken.position
	if warpPointAt(tile_grid_loc) != null:
		emit_signal("warp_point_hit", warpPointAt(tile_grid_loc))


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
	var result = object.position / TILE_SIZE
	return Vector2(floori(result.x), floori(result.y))


static func gridPositionToCanvasPosition(grid_position: Vector2) -> Vector2:
	return grid_position * TILE_SIZE


static func centerTileOnScreenLocation() -> Vector2:
	var result: Vector2 = GlobalProgramData.NATIVE_RESOLUTION / TILE_SIZE / 2
	result = Vector2(floori(result.x), floori(result.y))
	return gridPositionToCanvasPosition(result)


# Returns warp point or null if none present
func warpPointAt(grid_tile: Vector2) -> WarpPoint:
	for warp_point in get_node("WarpPoints").get_children():
		if gridCoordMatch(warp_point, grid_tile):
			return warp_point
	return null


func gridCoordMatch(object, coord: Vector2) -> bool:
	return gridPosition(object).x == int(coord.x) and gridPosition(object).y == int(coord.y)
