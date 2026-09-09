class_name OverworldMap
extends Node2D

const TILE_SIZE: int = 16

var map_name: String
signal party_stepped

signal warp_point_hit
signal blueprint_collected
signal mod_station_activated

func _ready() -> void:
	getPartyToken().map = self
	getPartyToken().stepped.connect(partyStepped)
	connectActiveObjectSignals()


func initialize(name_in: String, party_grid_position: Vector2):
	map_name = name_in
	getPartyToken().setGridPosition(party_grid_position)
	updateCamera()


func connectActiveObjectSignals() -> void:
	for object in getActiveMapObjects():
		if object is WarpPoint:
			object.warp.connect(warpPointHit)
		elif object is ModificationStation:
			object.used.connect(modificationStationActivated)
		elif object is BlueprintContainer:
			object.opened.connect(blueprintContainerOpened)


func warpPointHit(destination: OverworldPosition) -> void:
	emit_signal("warp_point_hit", destination)


func modificationStationActivated() -> void:
	emit_signal("mod_station_activated")


func blueprintContainerOpened(blueprint) -> void:
	emit_signal("blueprint_collected", blueprint)


func partyStepped() -> void:
	updateCamera()
	emit_signal("party_stepped")


func updateCamera() -> void:
	position = centerTileOnScreenLocation() - $PartyToken.position


func tileIsTraversable(tile_loc: Vector2) -> bool:
	for tile_map in getTileMaps():
		if tile_map.isSolidTile(tile_loc):
			return false
	for object in $ActiveObjects.get_children():
		if object.is_solid and gridCoordMatch(object, tile_loc):
			return false
	return true


func getPartyToken() -> PartyToken:
	return $PartyToken


func getTileMaps() -> Array:
	var result = []
	for tile_map in get_node("TileMapLayersLower").get_children():
		result.append(tile_map)
	for tile_map in get_node("TileMapLayersUpper").get_children():
		result.append(tile_map)
	return result


func getActiveMapObjects() -> Array:
	return get_node("ActiveObjects").get_children()


func getScriptTriggers() -> Array:
	var results = []
	for node in get_node("ActiveObjects").get_children():
		if node is ScriptTrigger:
			results.append(node)
	return results


func getBlueprintContainers() -> Array:
	var results = []
	for node in get_node("ActiveObjects").get_children():
		if node is BlueprintContainer:
			results.append(node)
	return results


func getModificationStations() -> Array:
	var results = []
	for node in get_node("ActiveObjects").get_children():
		if node is ModificationStation:
			results.append(node)
	return results


static func gridPosition(object) -> Vector2:
	var result = object.position / TILE_SIZE
	return Vector2(floori(result.x), floori(result.y))


static func vectorGridPosition(vector: Vector2) -> Vector2:
	var result = vector / TILE_SIZE
	return Vector2(floori(result.x), floori(result.y))


static func gridPositionToCanvasPosition(grid_position: Vector2) -> Vector2:
	return grid_position * TILE_SIZE


static func centerTileOnScreenLocation() -> Vector2:
	var result: Vector2 = GlobalProgramData.NATIVE_RESOLUTION / TILE_SIZE / 2
	result = Vector2(floori(result.x), floori(result.y))
	return gridPositionToCanvasPosition(result)


func activeMapObjectAt(grid_position: Vector2) -> ActiveMapObject:
	for object in getActiveMapObjects():
		if gridCoordMatch(object, grid_position):
			return object
	return null


# Returns warp point or null if none present
func warpPointAt(grid_position: Vector2) -> WarpPoint:
	for node in get_node("ActiveObjects").get_children():
		if node is WarpPoint and gridCoordMatch(node, grid_position):
			return node
	return null


func gridCoordMatch(object, coord: Vector2) -> bool:
	return gridPosition(object).x == int(coord.x) and gridPosition(object).y == int(coord.y)


# Returns encounter zone party token occupies, or null if none
func partyEncounterZone() -> EncounterZone:
	for zone in $EncounterZones.get_children():
		if zone.tokenIsInside($PartyToken):
			return zone
	return null
