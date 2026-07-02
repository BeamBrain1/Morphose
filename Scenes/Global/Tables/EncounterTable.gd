extends Node

# Inner array contains lists of EnemyTypes
static var table: Array[Array] = []


func _init() -> void:
	buildEncounterList()


static func buildEncounterList() -> void:
	table = []
	table.append([EnemyTable.getEnemyByName("Worker")])
	table.append([EnemyTable.getEnemyByName("Worker"), EnemyTable.getEnemyByName("Worker")])
	table.append([EnemyTable.getEnemyByName("Worker"), EnemyTable.getEnemyByName("Worker"), EnemyTable.getEnemyByName("Worker"), EnemyTable.getEnemyByName("Worker")])


# Returns encounter at index
# If index exceeds table size, get last entry
static func getEncounterAtIndex(index: int) -> Array:
	if index >= table.size():
		return table.back()
	else:
		return table[index]
