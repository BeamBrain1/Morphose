class_name PartyToken
extends ActiveMapObject

var map: OverworldMap

signal interact

var last_step_scripted: bool = false


func _ready() -> void:
	super()
	play()


func _process(delta) -> void:
	super(delta)


func attemptMoveUp(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.UP])
	attemptMoveTo(GlobalProgramData.DIRECTION.UP, scripted)


func attemptMoveDown(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.DOWN])
	attemptMoveTo(GlobalProgramData.DIRECTION.DOWN, scripted)


func attemptMoveLeft(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.LEFT])
	attemptMoveTo(GlobalProgramData.DIRECTION.LEFT, scripted)


func attemptMoveRight(scripted: bool = false, change_direction: bool = true) -> void:
	if change_direction:
		play(GlobalProgramData.direction_string[GlobalProgramData.DIRECTION.RIGHT])
	attemptMoveTo(GlobalProgramData.DIRECTION.RIGHT, scripted)


func attemptMoveTo(direction: GlobalProgramData.DIRECTION, scripted: bool = false):
	var direction_vector = GlobalProgramData.direction_vector[direction]
	var destination_tile: Vector2i = OverworldMap.gridPosition(self) + direction_vector
	if map.tileIsTraversable(destination_tile):
		last_step_scripted = scripted
		push(direction)
	else:	# If we can't move to the tile, step is imemdiately finished
		emit_signal("stepped")


func attemptInteract() -> void:
	var interact_target = map.activeMapObjectAt(getInteractingObjectPosition())
	if interact_target != null:
		interact_target.interactedWith()


func updateGlobalPartyPosition() -> void:
	var overworld_position: OverworldPosition = OverworldPosition.new(map.map_name, OverworldMap.gridPosition(self))
	ActiveSaveData.party.setLocationAndDirection(overworld_position, currentFacingDirection())


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


# Overrides parent.
func arriveAtDestination() -> void:
	setGridPosition(move_to_tile)
	is_moving = false
	if not last_step_scripted:
		stepOnObjectAtCurrentPosition()
	emit_signal("stepped")
