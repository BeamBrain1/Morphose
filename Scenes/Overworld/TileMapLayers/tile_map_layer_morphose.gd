class_name TileMapLayerMorphose
extends TileMapLayer

# Array of Vector2s. Solid tiles are those that the player cannot enter
@export var solid_tiles: Array


# Indicates whether a tile at a given position is solid (non-traversable)
func isSolidTile(tile_at: Vector2) -> bool:
	for tile in solid_tiles:
		if atlasCoordMatch(tile_at, tile):
			return true
	return false


func atlasCoordMatch(tile_at: Vector2, atlas_coord: Vector2) -> bool:
	return int(get_cell_atlas_coords(tile_at).x) == int(atlas_coord.x) and int(get_cell_atlas_coords(tile_at).y) == int(atlas_coord.y)
