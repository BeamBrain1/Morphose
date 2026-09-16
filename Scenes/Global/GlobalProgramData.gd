extends Node

const NATIVE_RESOLUTION = Vector2(320, 240)

const ADD_DEFECTOR_BEFORE_BATTLE = 9
const ADD_SCHOLAR_BEFORE_BATTLE = 17

static var all_blueprints: Array = BlueprintLoader.blueprintList()

enum DIRECTION {UP, DOWN, LEFT, RIGHT}

const direction_vector: Dictionary = {
	DIRECTION.UP: Vector2.UP,
	DIRECTION.RIGHT: Vector2.RIGHT,
	DIRECTION.DOWN: Vector2.DOWN,
	DIRECTION.LEFT: Vector2.LEFT
}
