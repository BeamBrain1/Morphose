extends Node

static var table: Dictionary = {}


func _init() -> void:
	buildEnemyList()


static func buildEnemyList() -> void:
	
	table = {}
	
	var current_enemy = EnemyType.new()
	current_enemy.name = "Worker"
	current_enemy.hp = 20
	current_enemy.tech_points = 10
	current_enemy.attack = 5
	current_enemy.defense = 6
	current_enemy.senses = 4
	current_enemy.speed = 8
	current_enemy.giveBlueprintByNameAndTier("Claw", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Darter"
	current_enemy.hp = 10
	current_enemy.tech_points = 15
	current_enemy.attack = 5
	current_enemy.defense = 2
	current_enemy.senses = 10
	current_enemy.speed = 20
	current_enemy.giveBlueprintByNameAndTier("Chaingun", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Shellon"
	current_enemy.hp = 30
	current_enemy.tech_points = 15
	current_enemy.attack = 10
	current_enemy.defense = 12
	current_enemy.senses = 5
	current_enemy.speed = 6
	current_enemy.giveBlueprintByNameAndTier("Claw", 1)
	current_enemy.giveBlueprintByNameAndTier("Hammer", 1)
	current_enemy.giveBlueprintByNameAndTier("Aegis", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Hunter"
	current_enemy.hp = 30
	current_enemy.tech_points = 15
	current_enemy.attack = 10
	current_enemy.defense = 8
	current_enemy.senses = 10
	current_enemy.speed = 10
	current_enemy.giveBlueprintByNameAndTier("Claw", 1)
	current_enemy.giveBlueprintByNameAndTier("Acid Spit", 1)
	addEnemyToTable(current_enemy)


static func getEnemyByName(name_in: String) -> EnemyType:
	return table[name_in]


static func addEnemyToTable(enemy: EnemyType):
	table[enemy.name] = enemy
