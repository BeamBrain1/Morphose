extends Node

const NATIVE_RESOLUTION = Vector2(320, 240)

const ADD_DEFECTOR_BEFORE_BATTLE = 9
const ADD_SCHOLAR_BEFORE_BATTLE = 17

static var all_blueprints: Array = BlueprintLoader.blueprintList()

const DEBUG_MODE: bool = true

enum DIRECTION {UP, DOWN, LEFT, RIGHT}

const direction_vector: Dictionary = {
	DIRECTION.UP: Vector2i.UP,
	DIRECTION.RIGHT: Vector2i.RIGHT,
	DIRECTION.DOWN: Vector2i.DOWN,
	DIRECTION.LEFT: Vector2i.LEFT
}

const direction_string: Dictionary = {
	DIRECTION.UP: "up",
	DIRECTION.RIGHT: "right",
	DIRECTION.DOWN: "down",
	DIRECTION.LEFT: "left"
}

func getRandomDirection() -> DIRECTION:
	var direction_array = [DIRECTION.UP, DIRECTION.RIGHT, DIRECTION.DOWN, DIRECTION.LEFT]
	return direction_array[randi() % direction_array.size()]
