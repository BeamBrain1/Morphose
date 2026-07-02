extends Node

const VIEWPORT_RESOLUTION = Vector2(320, 240)

static var all_blueprints: Array = BlueprintLoader.blueprintList()

enum COMBAT_STAT {HP, ATTACK, DEFENSE, SENSES, SPEED, TECH_POINTS}
