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


func attemptMoveTo(direction: GlobalProgramData.DIRECTION, scripted: bool = false, change_direction: bool = true):
	if not is_moving:
		if change_direction:
			play(GlobalProgramData.direction_string[direction])
		var direction_vector = GlobalProgramData.direction_vector[direction]
		var destination_tile: Vector2i = OverworldMap.gridPosition(self) + direction_vector
		if map.tileIsTraversable(destination_tile):
			last_step_scripted = scripted
			push(direction)
		else:	# If we can't move to the tile, step is imemdiately finished
			emit_signal("stepped", false)


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


# Returns true if there is an interact target to step on, false otherwise

func stepOnObjectAtCurrentPosition() -> bool:
	var interact_target = map.nonPartyActiveMapObjectAt(OverworldMap.gridPosition(self))
	if interact_target != null:
		interact_target.steppedOn()
	return interact_target != null


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
	var object_at_current_position: bool = false
	if not last_step_scripted:
		object_at_current_position = stepOnObjectAtCurrentPosition()
	emit_signal("stepped", not (last_step_scripted or object_at_current_position))
