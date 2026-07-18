extends Node

# Inner array contains lists of EnemyTypes
static var table: Array[Array] = []


func _init() -> void:
	buildEncounterList()


static func buildEncounterList() -> void:
	table = []
	
	table.append([enemy("Livestock")])
	table.append([enemy("Livestock")])
	table.append([enemy("Livestock")])
	table.append([enemy("Livestock")])
	table.append([enemy("Livestock")])
	table.append([enemy("Worker")])
	table.append([enemy("Worker")])
	table.append([enemy("Worker"), enemy("Worker")])
	table.append([enemy("Worker"), enemy("Worker")])
	table.append([enemy("Enforcer"), enemy("Enforcer")])
	table.append([enemy("Worker"), enemy("Enforcer"), enemy("Worker")])
	table.append([enemy("Boss")])
	table.append([enemy("Hunter"), enemy("Hunter")])
	table.append([enemy("Darter"), enemy("Shellon")])
	table.append([enemy("Hunter"), enemy("Darter"), enemy("Shellon")])
	table.append([enemy("Pyroid"), enemy("Pyroid")])
	table.append([enemy("Brute"), enemy("Brute")])
	table.append([enemy("Pyroid"), enemy("Brute"), enemy("Pyroid")])
	table.append([enemy("Pyroid"), enemy("Gang Boss"), enemy("Brute")])
	table.append([enemy("Hunter"), enemy("Darter"), enemy("Shellon")])
	table.append([enemy("Pack Bug"), enemy("Pack Bug"), enemy("Pack Bug")])
	table.append([enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer")])
	table.append([enemy("Queen")])


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


static func getEncounterBioEnergyValue(index: int) -> int:
	var result = 0
	for enemy in table[index]:
		result += enemy.getBioEnergyValue()
	return result
