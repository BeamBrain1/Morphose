extends Node

const VIEWPORT_RESOLUTION = Vector2(320, 240)

const ADD_DEFECTOR_AFTER_BATTLE = 1
const ADD_SCHOLAR_AFTER_BATTLE = 8

static var all_blueprints: Array = BlueprintLoader.blueprintList()

enum COMBAT_STAT {HP, ATTACK, DEFENSE, SENSES, SPEED, TECH_POINTS}
