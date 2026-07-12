extends Node

const VIEWPORT_RESOLUTION = Vector2(320, 240)

const ADD_DEFECTOR_BEFORE_BATTLE = 9
const ADD_SCHOLAR_BEFORE_BATTLE = 17

static var all_blueprints: Array = BlueprintLoader.blueprintList()

enum COMBAT_STAT {HP, ATTACK, DEFENSE, SENSES, SPEED, TECH_POINTS}
