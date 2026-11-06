class_name NPC
extends ActiveMapObject

var map: OverworldMap
@export var initial_direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	faceDirection(initial_direction)


func _process(delta) -> void:
	super(delta)


func push(direction: GlobalProgramData.DIRECTION, change_direction: bool = true) -> void:
	attemptMoveTo(direction, change_direction)


func attemptMoveTo(direction: GlobalProgramData.DIRECTION, change_direction: bool = true):
	if change_direction:
		play(GlobalProgramData.direction_string[direction])
	var direction_vector = GlobalProgramData.direction_vector[direction]
	var destination_tile: Vector2i = OverworldMap.gridPosition(self) + direction_vector
	if map.tileIsTraversable(destination_tile):
		startMoveTo(direction)
	else:	# If we can't move to the tile, step is imemdiately finished
		emit_signal("stepped")


func startMoveTo(direction: GlobalProgramData.DIRECTION):
	if not is_moving:
		current_travel_vector = GlobalProgramData.direction_vector[direction]
		move_to_tile = OverworldMap.gridPosition(self) + current_travel_vector
		distance_moved_this_push = 0
		is_moving = true


func faceDirection(direction: GlobalProgramData.DIRECTION) -> void:
	play(GlobalProgramData.direction_string[direction])


func assignMap(map_in: OverworldMap) -> void:
	map = map_in


func turnRandom() -> void:
	# 1 in 8 chance of turning
	if randi() % 8 == 0:
		faceDirection(GlobalProgramData.getRandomDirection())
