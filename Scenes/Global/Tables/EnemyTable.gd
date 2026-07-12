extends Node

static var table: Dictionary = {}


func _init() -> void:
	buildEnemyList()


static func buildEnemyList() -> void:
	
	table = {}
	
	var current_enemy = EnemyType.new()
	current_enemy.name = "Livestock"
	current_enemy.hp = 10
	current_enemy.tech_points = 5
	current_enemy.attack = 1
	current_enemy.defense = 1
	current_enemy.senses = 1
	current_enemy.speed = 1
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Worker"
	current_enemy.hp = 10
	current_enemy.tech_points = 8
	current_enemy.attack = 2
	current_enemy.defense = 6
	current_enemy.senses = 4
	current_enemy.speed = 5
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Enforcer"
	current_enemy.hp = 15
	current_enemy.tech_points = 12
	current_enemy.attack = 6
	current_enemy.defense = 6
	current_enemy.senses = 4
	current_enemy.speed = 5
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Boss"
	current_enemy.hp = 80
	current_enemy.tech_points = 10
	current_enemy.attack = 12
	current_enemy.defense = 7
	current_enemy.senses = 10
	current_enemy.speed = 8
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	current_enemy.installBlueprintByNameAndTier("Hammer", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Darter"
	current_enemy.hp = 10
	current_enemy.tech_points = 15
	current_enemy.attack = 10
	current_enemy.defense = 3
	current_enemy.senses = 6
	current_enemy.speed = 18
	current_enemy.installBlueprintByNameAndTier("Chaingun", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Shellon"
	current_enemy.hp = 35
	current_enemy.tech_points = 10
	current_enemy.attack = 7
	current_enemy.defense = 12
	current_enemy.senses = 5
	current_enemy.speed = 5
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	current_enemy.installBlueprintByNameAndTier("Hammer", 1)
	current_enemy.installBlueprintByNameAndTier("Mucus", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Hunter"
	current_enemy.hp = 20
	current_enemy.tech_points = 15
	current_enemy.attack = 8
	current_enemy.defense = 8
	current_enemy.senses = 8
	current_enemy.speed = 8
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	current_enemy.installBlueprintByNameAndTier("Acid Spit", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Pyroid"
	current_enemy.hp = 25
	current_enemy.tech_points = 15
	current_enemy.attack = 5
	current_enemy.defense = 8
	current_enemy.senses = 12
	current_enemy.speed = 16
	current_enemy.installBlueprintByNameAndTier("Flamejet", 1)
	current_enemy.installBlueprintByNameAndTier("Napalm", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Brute"
	current_enemy.hp = 40
	current_enemy.tech_points = 20
	current_enemy.attack = 10
	current_enemy.defense = 10
	current_enemy.senses = 10
	current_enemy.speed = 10
	current_enemy.installBlueprintByNameAndTier("Chaingun", 1)
	current_enemy.installBlueprintByNameAndTier("Hammer", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Gang Boss"
	current_enemy.hp = 120
	current_enemy.tech_points = 30
	current_enemy.attack = 13
	current_enemy.defense = 12
	current_enemy.senses = 10
	current_enemy.speed = 10
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	current_enemy.installBlueprintByNameAndTier("Chaingun", 1)
	current_enemy.installBlueprintByNameAndTier("Flechets", 1)
	addEnemyToTable(current_enemy)


static func getEnemyByName(name_in: String) -> EnemyType:
	return table[name_in]


static func addEnemyToTable(enemy: EnemyType):
	table[enemy.name] = enemy
