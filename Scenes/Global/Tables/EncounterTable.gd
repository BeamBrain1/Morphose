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
	table.append([enemy("Pyroid"), enemy("Brute"), enemy("Pyroid")])
	table.append([enemy("Gang Boss")])
	table.append([enemy("Hunter"), enemy("Darter"), enemy("Shellon")])
	table.append([enemy("Pack Bug"), enemy("Pack Bug"), enemy("Pack Bug")])
	table.append([enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer"), enemy("Swarmer")])
	table.append([enemy("Pack Bug"), enemy("Pack Bug"), enemy("Pack Bug")])
	table.append([enemy("Pack Bug"), enemy("Pack Bug"), enemy("Pack Bug")])
	table.append([enemy("Queen")])
	table.append([enemy("Saiyon"), enemy("Harrier")])
	table.append([enemy("Marauder"), enemy("Marauder")])
	table.append([enemy("Saiyon"), enemy("Saiyon"), enemy("Marauder")])
	table.append([enemy("Saiyon"), enemy("Harrier"), enemy("Harrier")])
	table.append([enemy("Aquila"), enemy("Brawler")])
	table.append([enemy("Brawler"), enemy("Marksman")])
	table.append([enemy("Aquila"), enemy("Aquila"), enemy("Brawler")])
	table.append([enemy("Brawler"), enemy("Marksman"), enemy("Marksman")])
	table.append([enemy("Aquila"), enemy("Stoneback"), enemy("Marksman")])
	table.append([enemy("Aquila"), enemy("Aquila"), enemy("Marksman")])
	table.append([enemy("Aquila"), enemy("Aquila"), enemy("Marksman"), enemy("Marksman")])
	table.append([enemy("Stoneback"), enemy("Stoneback"), enemy("Marksman"), enemy("Marksman"), enemy("Marksman")])
	table.append([enemy("Aquila"), enemy("Stoneback")])
	table.append([enemy("Searcher"), enemy("Searcher")])
	table.append([enemy("Searcher"), enemy("Searcher"), enemy("Launcher"), enemy("Launcher")])
	table.append([enemy("Tanker"), enemy("Tanker"), enemy("Launcher"), enemy("Launcher")])
	table.append([enemy("Tanker"), enemy("Tanker"), enemy("Launcher"), enemy("Searcher"), enemy("Searcher"), enemy("Searcher")])
	table.append([enemy("Tanker"), enemy("Silo Lord"), enemy("Tanker")])
	table.append([enemy("Toxoid"), enemy("Toxoid")])
	table.append([enemy("Toxoid"), enemy("Toxoid")])
	table.append([enemy("Toxoid"), enemy("Toxoid"), enemy("Toxoid")])
	table.append([enemy("Toxoid"), enemy("Toxoid"), enemy("Toxoid")])
	table.append([enemy("Raptor"), enemy("Raptor")])
	table.append([enemy("Raptor"), enemy("Raptor"), enemy("Raptor")])
	table.append([enemy("Raptor"), enemy("Raptor"), enemy("Raptor"), enemy("Raptor")])
	table.append([enemy("Raptor"), enemy("Raptor"), enemy("Raptor"), enemy("Raptor"), enemy("Raptor"), enemy("Raptor")])
	table.append([enemy("APU-019"), enemy("APU-019"), enemy("APU-019"), enemy("APU-019"), enemy("APU-019"), enemy("APU-019"), enemy("APU-019"), enemy("APU-019")])
	table.append([enemy("Prototype")])
	table.append([enemy("Crab"), enemy("Crab")])
	table.append([enemy("Crab"), enemy("Crab")])
	table.append([enemy("Crab"), enemy("Crab"), enemy("Crab")])
	table.append([enemy("Crab"), enemy("Crab"), enemy("Crab")])
	table.append([enemy("Barnacle"), enemy("Barnacle")])
	table.append([enemy("Barnacle"), enemy("Barnacle"), enemy("Barnacle")])
	table.append([enemy("Barnacle"), enemy("Barnacle"), enemy("Barnacle"), enemy("Barnacle")])
	table.append([enemy("Barnacle"), enemy("Barnacle"), enemy("Barnacle"), enemy("Barnacle"), enemy("Barnacle"), enemy("Barnacle")])
	table.append([enemy("King Crab"), enemy("King Crab"), enemy("King Crab"), enemy("King Crab")])
	table.append([enemy("Shark"), enemy("Shark")])
	table.append([enemy("Shark"), enemy("Shark")])
	table.append([enemy("Shark"), enemy("Shark"), enemy("Shark")])
	table.append([enemy("Shark"), enemy("Shark"), enemy("Shark")])
	table.append([enemy("Pulser"), enemy("Pulser")])
	table.append([enemy("Pulser"), enemy("Pulser"), enemy("Pulser")])
	table.append([enemy("Pulser"), enemy("Pulser"), enemy("Pulser"), enemy("Pulser")])
	table.append([enemy("Pulser"), enemy("Pulser"), enemy("Pulser"), enemy("Pulser"), enemy("Pulser"), enemy("Pulser")])
	table.append([enemy("Prometheus"), enemy("Pulser"), enemy("Pulser")])
	table.append([enemy("Zenith")])

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


static func encounterHasEnemy(encounter: Array, name_in: String) -> bool:
	for enemy in encounter:
		if name_in.matchn(enemy.name):
			return true
	return false
