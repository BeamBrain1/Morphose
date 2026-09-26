class_name OverworldMap
extends Node2D

const TILE_SIZE: int = 16
const ACTIVE_OBJECT_DIRECTORY = "res://Scenes/Overowrld/ActiveObjects/"

var map_name: String

signal party_stepped
signal request_script_execution
signal on_map_load


func _ready() -> void:
	getPartyToken().map = self
	getPartyToken().stepped.connect(partyStepped)


func initialize(name_in: String, party_grid_position: Vector2):
	map_name = name_in
	getPartyToken().setGridPosition(party_grid_position)
	assignSelfToNPCs()
	connectActiveObjectScripts()
	updateCamera()
	emit_signal("on_map_load", getOnLoadScript())


func connectActiveObjectScripts() -> void:
	for obj in getActiveMapObjects():
		obj.request_script_execution.connect(requestScriptExecution)


# On-load script is executed when map is loaded. First child node that is a MapScript (additional MapScript children do nothing)
func getOnLoadScript() -> MapScript:
	for node in get_children():
		if node is MapScript:
			return node
	return null


func partyStepped(scripted: bool = false) -> void:
	updateCamera()
	emit_signal("party_stepped", scripted)


func updateCamera() -> void:
	position = centerTileOnScreenLocation() - $PartyToken.position


func assignSelfToNPCs() -> void:
	for npc in getNPCs():
		npc.assignMap(self)


func tileIsTraversable(tile_loc: Vector2) -> bool:
	for tile_map in getTileMaps():
		if tile_map.isSolidTile(tile_loc):
			return false
	for object in getActiveMapObjects():
		if object.is_solid and gridCoordMatch(object, tile_loc):
			return false
	if gridCoordMatch($PartyToken, tile_loc):
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
	for node in getActiveMapObjects():
		if node is ScriptTrigger:
			results.append(node)
	return results


func getNPCs() -> Array:
	var results = []
	for node in getActiveMapObjects():
		if node is NPC:
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


func getActiveObjectByName(name_in: String) -> ActiveMapObject:
	for object in getActiveMapObjects():
		if name_in.matchn(object.name):
			return object
	push_error("Active object not found: " + name_in)
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


func spawnActiveObject(scene_name: String, node_name: String, grid_position: Vector2) -> void:
	var active_object = load(ACTIVE_OBJECT_DIRECTORY + scene_name + ".tscn").instantiate()
	add_child(active_object)
	active_object.setGridPosition(grid_position)
	active_object.request_script_execution.connect(requestScriptExecution)


func destroyActiveObject(node_name: String) -> void:
	var obj = getActiveObjectByName(node_name)
	if obj == null:
		push_error("Active Object not found: " + node_name)
		await get_tree().process_frame		# Wait 1 frame for object to be destroyed before returning
	else:
		obj.call_deferred("queue_free")


func getMapLayer(layer: String) -> TileMapLayerMorphose:
	if $TileMapLayersLower.has_node(layer):
		return $TileMapLayersLower.get_node(layer)
	if $TileMapLayersUpper.has_node(layer):
		return $TileMapLayersUpper.get_node(layer)
	push_error("Map layer not found: " + layer)
	return null


# Changes map tile in specified layer and position to specified cell in tile atlas
func setMapTile(layer: String, grid_position: Vector2, atlas_offset: Vector2) -> void:
	var map_layer: TileMapLayerMorphose = getMapLayer(layer)
	map_layer.set_cell(grid_position, 0, atlas_offset)


func getNPC(npc_name: String) -> NPC:
	var active_object = getActiveObjectByName(npc_name)
	if active_object != null and active_object.name == npc_name:
		return active_object
	push_error("NPC not found: " + npc_name)
	return null


func requestScriptExecution(map_script: MapScript) -> void:
	emit_signal("request_script_execution", map_script)
