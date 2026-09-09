class_name PartyToken
extends AnimatedSprite2D

var map: OverworldMap

signal stepped
signal interact


func _process(delta) -> void:
	pass


func attemptMoveUp() -> void:
	play("up")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.UP
	attemptMoveTo(move_destination)


func attemptMoveDown() -> void:
	play("down")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.DOWN
	attemptMoveTo(move_destination)


func attemptMoveLeft() -> void:
	play("left")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.LEFT
	attemptMoveTo(move_destination)


func attemptMoveRight() -> void:
	play("right")
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.RIGHT
	attemptMoveTo(move_destination)


func attemptMoveTo(destination_tile: Vector2):
	if map.tileIsTraversable(destination_tile):
		step(destination_tile)


func attemptInteract() -> void:
	var interact_target = map.activeMapObjectAt(getInteractingObjectPosition())
	if interact_target != null:
		interact_target.interact()


func updateGlobalPartyPosition() -> void:
	var overworld_position: OverworldPosition = OverworldPosition.new(map.map_name, OverworldMap.gridPosition(self))
	ActiveSaveData.party.setLocationAndDirection(overworld_position, currentFacingDirection())


func step(tile_grid_loc: Vector2) -> void:
	setGridPosition(tile_grid_loc)
	emit_signal("stepped")
	stepOnObjectAtCurrentPosition()


func setGridPosition(tile_grid_loc: Vector2) -> void:
	position = OverworldMap.gridPositionToCanvasPosition(tile_grid_loc)
	updateGlobalPartyPosition()


func stepOnObjectAtCurrentPosition() -> void:
	var interact_target = map.activeMapObjectAt(OverworldMap.gridPosition(self))
	if interact_target != null:
		interact_target.steppedOn()


# Get the position of the object the party is attempting to interact with based on position and direction
func getInteractingObjectPosition() -> Vector2:
	return OverworldMap.gridPosition(self) + GlobalProgramData.direction_vector[currentFacingDirection()]


func currentFacingDirection() -> GlobalProgramData.DIRECTION:
	if animation == "up":
		return GlobalProgramData.DIRECTION.UP
	if animation == "down":
		return GlobalProgramData.DIRECTION.DOWN
	if animation == "left":
		return GlobalProgramData.DIRECTION.LEFT
	if animation == "right":
		return GlobalProgramData.DIRECTION.RIGHT

	push_error("Unable to convert animation to direction: " + animation)
	return GlobalProgramData.DIRECTION.UP
