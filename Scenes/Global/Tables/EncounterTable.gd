extends Node

# Inner array contains lists of EnemyTypes
static var table: Array[Array] = []


func _init() -> void:
	buildEncounterList()


static func buildEncounterList() -> void:
	table = []
	table.append([enemy("Worker")])
	table.append([enemy("Worker"), enemy("Worker")])
	table.append([enemy("Worker"), enemy("Worker"), enemy("Worker"), enemy("Worker")])
	table.append([enemy("Boss")])
	table.append([enemy("Hunter"), enemy("Hunter")])
	table.append([enemy("Darter"), enemy("Shellon")])
	table.append([enemy("Hunter"), enemy("Darter"), enemy("Darter")])


# Returns encounter at index
# If index exceeds table size, get last entry
static func getEncounterAtIndex(index: int) -> Array:
	if index >= table.size():
		return table.back()
	else:
		return table[index]


# Mostly used for brevity. Get enemy by name
static func enemy(name_in: String) -> EnemyType:
	return EnemyTable.getEnemyByName(name_in)
