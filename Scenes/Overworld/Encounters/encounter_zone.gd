class_name EncounterZone
extends ColorRect

var active: bool = true		# Zone only triggers encounters if flagged as active
var active_debug_color: Color = Color(1, 0, 0, 0.5)
var inactive_debug_color: Color = Color(0.5, 0.5, 0.5, 0.5)

func tokenIsInside(token: PartyToken) -> bool:
	var token_grid_position = OverworldMap.gridPosition(token)
	return upperLeftCornerGridPosition().x <= token_grid_position.x and token_grid_position.x <= lowerRightCornerGridPosition().x and upperLeftCornerGridPosition().y <= token_grid_position.y and token_grid_position.y <= lowerRightCornerGridPosition().y


func upperLeftCornerGridPosition() -> Vector2:
	return OverworldMap.gridPosition(self)


func lowerRightCornerGridPosition() -> Vector2:
	return OverworldMap.vectorGridPosition(position + size) - Vector2(1, 1)		# Lower right grid position extends 1 past visible area


func getEncounters() -> Array:
	return get_children()


# Get a random encounter. Returns the enemy list (controller doesn't need encounter weight)
func getRandomEncounter() -> Array:
	var encounters: Array = getEncounters()
	var total_weight: int = 0
	for encounter in encounters:
		total_weight += encounter.weight
	var rand = randi() % total_weight
	total_weight = 0
	for encounter in encounters:
		total_weight += encounter.weight
		if rand < total_weight:
			return encounter.getEnemies()
	push_error("Error retrieving random encounter")
	return []


func activate() -> void:
	active = true
	color = active_debug_color


func deactivate() -> void:
	active = false
	color = inactive_debug_color
