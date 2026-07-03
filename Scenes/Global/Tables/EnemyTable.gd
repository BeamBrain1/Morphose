extends Node

static var table: Dictionary = {}


func _init() -> void:
	buildEnemyList()


static func buildEnemyList() -> void:
	
	table = {}
	
	var worker = EnemyType.new()
	worker.name = "Worker"
	worker.hp = 20
	worker.tech_points = 10
	worker.attack = 5
	worker.defense = 6
	worker.senses = 4
	worker.speed = 8
	worker.giveBlueprintByNameAndTier("Claw", 1)
	worker.giveBlueprintByNameAndTier("Enrage", 1)
	addEnemyToTable(worker)


static func getEnemyByName(name_in: String) -> EnemyType:
	return table[name_in]


static func addEnemyToTable(enemy: EnemyType):
	table[enemy.name] = enemy
