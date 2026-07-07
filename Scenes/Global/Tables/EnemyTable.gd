extends Node

static var table: Dictionary = {}


func _init() -> void:
	buildEnemyList()


static func buildEnemyList() -> void:
	
	table = {}
	
	var current_enemy = EnemyType.new()
	current_enemy.name = "Worker"
	current_enemy.hp = 10
	current_enemy.tech_points = 10
	current_enemy.attack = 5
	current_enemy.defense = 6
	current_enemy.senses = 4
	current_enemy.speed = 8
	current_enemy.giveBlueprintByNameAndTier("Claw", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Boss"
	current_enemy.hp = 100
	current_enemy.tech_points = 25
	current_enemy.attack = 10
	current_enemy.defense = 10
	current_enemy.senses = 8
	current_enemy.speed = 8
	current_enemy.giveBlueprintByNameAndTier("Claw", 1)
	current_enemy.giveBlueprintByNameAndTier("Hammer", 1)
	current_enemy.giveBlueprintByNameAndTier("Napalm", 1)
	current_enemy.giveBlueprintByNameAndTier("Aegis", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Darter"
	current_enemy.hp = 15
	current_enemy.tech_points = 20
	current_enemy.attack = 10
	current_enemy.defense = 3
	current_enemy.senses = 12
	current_enemy.speed = 24
	current_enemy.giveBlueprintByNameAndTier("Chaingun", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Shellon"
	current_enemy.hp = 40
	current_enemy.tech_points = 15
	current_enemy.attack = 10
	current_enemy.defense = 12
	current_enemy.senses = 5
	current_enemy.speed = 7
	current_enemy.giveBlueprintByNameAndTier("Claw", 1)
	current_enemy.giveBlueprintByNameAndTier("Hammer", 1)
	current_enemy.giveBlueprintByNameAndTier("Aegis", 1)
	current_enemy.giveBlueprintByNameAndTier("Mucus", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Hunter"
	current_enemy.hp = 30
	current_enemy.tech_points = 15
	current_enemy.attack = 10
	current_enemy.defense = 10
	current_enemy.senses = 10
	current_enemy.speed = 10
	current_enemy.giveBlueprintByNameAndTier("Claw", 1)
	current_enemy.giveBlueprintByNameAndTier("Laser", 1)
	current_enemy.giveBlueprintByNameAndTier("Acid Spit", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Pyroid"
	current_enemy.hp = 70
	current_enemy.tech_points = 25
	current_enemy.attack = 20
	current_enemy.defense = 12
	current_enemy.senses = 15
	current_enemy.speed = 18
	current_enemy.giveBlueprintByNameAndTier("Flame Jet", 1)
	current_enemy.giveBlueprintByNameAndTier("Napalm", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Brute"
	current_enemy.hp = 100
	current_enemy.tech_points = 20
	current_enemy.attack = 25
	current_enemy.defense = 20
	current_enemy.senses = 12
	current_enemy.speed = 12
	current_enemy.giveBlueprintByNameAndTier("Chaingun", 1)
	current_enemy.giveBlueprintByNameAndTier("Hammer", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Gang Boss"
	current_enemy.hp = 300
	current_enemy.tech_points = 50
	current_enemy.attack = 35
	current_enemy.defense = 25
	current_enemy.senses = 25
	current_enemy.speed = 30
	current_enemy.giveBlueprintByNameAndTier("Laser", 2)
	current_enemy.giveBlueprintByNameAndTier("Chaingun", 1)
	current_enemy.giveBlueprintByNameAndTier("Flechets", 1)
	addEnemyToTable(current_enemy)


static func getEnemyByName(name_in: String) -> EnemyType:
	return table[name_in]


static func addEnemyToTable(enemy: EnemyType):
	table[enemy.name] = enemy
