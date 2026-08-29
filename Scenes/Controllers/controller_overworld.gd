extends Controller

var danger_level: int = 0
const ENCOUNTER_RATE: int = 10
const ENCOUNTER_THRESHOLD: int = 100

const TILE_SIZE: int = 16


func partyStep(direction: GlobalProgramData.DIRECTION) -> void:
	danger_level += 1 + randi() % ENCOUNTER_RATE
	if danger_level >= ENCOUNTER_THRESHOLD:
		doEncounter()


func doEncounter() -> void:
	danger_level = 0
	print("Encounter")


func gridPosition(object) -> Vector2:
	return object.position / TILE_SIZE


static func gridPositionToCanvasPosition(grid_position: Vector2) -> Vector2:
	return grid_position * TILE_SIZE
