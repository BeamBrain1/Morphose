class_name PartyToken
extends ActiveMapObject

var map: OverworldMap

signal stepped
signal interact


func _process(delta) -> void:
	pass


func attemptMoveUp(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.UP])
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.UP
	attemptMoveTo(move_destination, scripted)


func attemptMoveDown(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.DOWN])
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.DOWN
	attemptMoveTo(move_destination, scripted)


func attemptMoveLeft(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.LEFT])
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.LEFT
	attemptMoveTo(move_destination, scripted)


func attemptMoveRight(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.RIGHT])
	var move_destination: Vector2 = OverworldMap.gridPosition(self) + Vector2.RIGHT
	attemptMoveTo(move_destination, scripted)


func push(direction: GlobalProgramData.DIRECTION, change_direction: bool = true) -> void:
	match direction:
		GlobalProgramData.DIRECTION.UP:
			attemptMoveUp(true, change_direction)
		GlobalProgramData.DIRECTION.RIGHT:
			attemptMoveRight(true, change_direction)
		GlobalProgramData.DIRECTION.DOWN:
			attemptMoveDown(true, change_direction)
		GlobalProgramData.DIRECTION.LEFT:
			attemptMoveLeft(true, change_direction)
		_:
			push_error("Unrecognized direction: " + str(direction))


func attemptMoveTo(destination_tile: Vector2, scripted: bool = false):
	if map.tileIsTraversable(destination_tile):
		step(destination_tile, scripted)


func attemptInteract() -> void:
	var interact_target = map.activeMapObjectAt(getInteractingObjectPosition())
	if interact_target != null:
		interact_target.interactedWith()


func updateGlobalPartyPosition() -> void:
	var overworld_position: OverworldPosition = OverworldPosition.new(map.map_name, OverworldMap.gridPosition(self))
	ActiveSaveData.party.setLocationAndDirection(overworld_position, currentFacingDirection())


func step(tile_grid_loc: Vector2, scripted: bool = false) -> void:
	setGridPosition(tile_grid_loc)
	emit_signal("stepped", scripted)
	if not scripted:
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


func faceDirection(direction: GlobalProgramData.DIRECTION) -> void:
	play(GlobalProgramData.direction_string[direction])


# Overrides parent. Party token "steps on" itself all the time but should do nothing
func steppedOn() -> void:
	pass
