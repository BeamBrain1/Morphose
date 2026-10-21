extends Node

static var table: Dictionary = {}


func _init() -> void:
	buildGlobalEnemyList()


static func buildGlobalEnemyList() -> void:
	
	table = {}
	
	### FACTORY ###
	var current_enemy = EnemyType.new()
	current_enemy.name = "Livestock"
	current_enemy.hp = 10
	current_enemy.tech_points = 5
	current_enemy.attack = 1
	current_enemy.defense = 1
	current_enemy.senses = 1
	current_enemy.speed = 1
	current_enemy.run_from_attempts_always_succeed = true
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Worker"
	current_enemy.hp = 8
	current_enemy.tech_points = 10
	current_enemy.attack = 1
	current_enemy.defense = 6
	current_enemy.senses = 4
	current_enemy.speed = 5
	current_enemy.never_crits = true
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Security"
	current_enemy.hp = 15
	current_enemy.tech_points = 10
	current_enemy.attack = 8
	current_enemy.defense = 6
	current_enemy.senses = 7
	current_enemy.speed = 6
	current_enemy.never_crits = true
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Overseer"
	current_enemy.hp = 100
	current_enemy.tech_points = 100
	current_enemy.attack = 6
	current_enemy.defense = 6
	current_enemy.senses = 12
	current_enemy.speed = 8
	current_enemy.never_crits = true
	current_enemy.is_boss = true
	current_enemy.installBlueprintByNameAndTier("Horn", 1)
	addEnemyToTable(current_enemy)
	
	### EARLY OVERWORLD ###
	current_enemy = EnemyType.new()
	current_enemy.name = "Darter"
	current_enemy.hp = 10
	current_enemy.tech_points = 35
	current_enemy.attack = 12
	current_enemy.defense = 3
	current_enemy.senses = 6
	current_enemy.speed = 22
	current_enemy.installBlueprintByNameAndTier("Auto Rifle", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Shellon"
	current_enemy.hp = 20
	current_enemy.tech_points = 35
	current_enemy.attack = 10
	current_enemy.defense = 10
	current_enemy.senses = 4
	current_enemy.speed = 4
	current_enemy.installBlueprintByNameAndTier("Claw", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Horn", 1)
	current_enemy.installBlueprintByNameAndTier("Mucus", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Hunter"
	current_enemy.hp = 20
	current_enemy.tech_points = 20
	current_enemy.attack = 12
	current_enemy.defense = 6
	current_enemy.senses = 10
	current_enemy.speed = 10
	current_enemy.installBlueprintByNameAndTier("Claw", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Laser", 1)
	addEnemyToTable(current_enemy)
	
	### CITY ###
	current_enemy = EnemyType.new()
	current_enemy.name = "Pyroid"
	current_enemy.hp = 25
	current_enemy.tech_points = 30
	current_enemy.attack = 10
	current_enemy.defense = 6
	current_enemy.senses = 10
	current_enemy.speed = 12
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	current_enemy.installBlueprintByNameAndTier("Flame Spit", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Brute"
	current_enemy.hp = 40
	current_enemy.tech_points = 30
	current_enemy.attack = 15
	current_enemy.defense = 6
	current_enemy.senses = 10
	current_enemy.speed = 10
	current_enemy.installBlueprintByNameAndTier("Claw", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Horn", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Gang Boss"
	current_enemy.hp = 100
	current_enemy.tech_points = 50
	current_enemy.attack = 20
	current_enemy.defense = 16
	current_enemy.senses = 14
	current_enemy.speed = 14
	current_enemy.is_boss = true
	current_enemy.installBlueprintByNameAndTier("Vise", 1, 3)
	current_enemy.installBlueprintByNameAndTier("Numb Gas", 1)
	addEnemyToTable(current_enemy)
	
	### SKELETON FOREST ###
	# This section will teach the importance of crowd control
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Pack Bug"
	current_enemy.hp = 40
	current_enemy.tech_points = 40
	current_enemy.attack = 20
	current_enemy.defense = 12
	current_enemy.senses = 14
	current_enemy.speed = 16
	current_enemy.installBlueprintByNameAndTier("Claw", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Horn", 1)
	current_enemy.installBlueprintByNameAndTier("Blitz", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Swarmer"
	current_enemy.hp = 10
	current_enemy.tech_points = 10
	current_enemy.attack = 20
	current_enemy.defense = 3
	current_enemy.senses = 16
	current_enemy.speed = 15
	current_enemy.installBlueprintByNameAndTier("Claw", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Queen"
	current_enemy.hp = 250
	current_enemy.tech_points = 80
	current_enemy.attack = 1
	current_enemy.defense = 14
	current_enemy.senses = 1
	current_enemy.speed = 20
	current_enemy.is_boss = true
	current_enemy.installBlueprintByNameAndTier("Swarm", 1)
	current_enemy.installBlueprintByNameAndTier("Marshal", 1)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	current_enemy.installBlueprintByNameAndTier("HydroCoat", 2)
	addEnemyToTable(current_enemy)
	
	### EASTERN PLAINS ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Saiyon"
	current_enemy.hp = 50
	current_enemy.tech_points = 30
	current_enemy.attack = 1
	current_enemy.defense = 10
	current_enemy.senses = 30
	current_enemy.speed = 20
	current_enemy.installBlueprintByNameAndTier("Psy pulse", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Enrage", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Marauder"
	current_enemy.hp = 70
	current_enemy.tech_points = 25
	current_enemy.attack = 30
	current_enemy.defense = 14
	current_enemy.senses = 18
	current_enemy.speed = 20
	current_enemy.installBlueprintByNameAndTier("Claw", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Horn", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Harrier"
	current_enemy.hp = 50
	current_enemy.tech_points = 20
	current_enemy.attack = 35
	current_enemy.defense = 14
	current_enemy.senses = 18
	current_enemy.speed = 22
	current_enemy.installBlueprintByNameAndTier("Auto Rifle", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Overclock", 1)
	addEnemyToTable(current_enemy)
	
	### SPACE CENTER ###
	
	# No Morphose here. Zenith is keeping them away.
	
	### MOUNTAIN OVERWORLD ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Brawler"
	current_enemy.hp = 70
	current_enemy.tech_points = 50
	current_enemy.attack = 15
	current_enemy.defense = 20
	current_enemy.senses = 25
	current_enemy.speed = 25
	current_enemy.installBlueprintByNameAndTier("Claw", 2)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Aquila"
	current_enemy.hp = 50
	current_enemy.tech_points = 60
	current_enemy.attack = 20
	current_enemy.defense = 10
	current_enemy.senses = 30
	current_enemy.speed = 40
	current_enemy.installBlueprintByNameAndTier("Claw", 2, 2)
	current_enemy.installBlueprintByNameAndTier("Frag Bomb", 1)
	current_enemy.installBlueprintByNameAndTier("Acid Mist", 1)
	addEnemyToTable(current_enemy)
	
	### MOUNTAIN ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Marksman"
	current_enemy.hp = 80
	current_enemy.tech_points = 50
	current_enemy.attack = 30
	current_enemy.defense = 20
	current_enemy.senses = 60
	current_enemy.speed = 30
	current_enemy.installBlueprintByNameAndTier("Laser", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Bullseye", 2)
	current_enemy.support_priority = 1
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Stoneback"
	current_enemy.hp = 60
	current_enemy.tech_points = 150
	current_enemy.attack = 30
	current_enemy.defense = 40
	current_enemy.senses = 30
	current_enemy.speed = 10
	current_enemy.installBlueprintByNameAndTier("Horn", 2)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Firefly"
	current_enemy.hp = 200
	current_enemy.tech_points = 130
	current_enemy.attack = 25
	current_enemy.defense = 15
	current_enemy.senses = 45
	current_enemy.speed = 45
	current_enemy.installBlueprintByNameAndTier("Claw", 2)
	current_enemy.installBlueprintByNameAndTier("Flame Spit", 2)
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	### MISSILE SILO ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Searcher"
	current_enemy.hp = 100
	current_enemy.tech_points = 80
	current_enemy.attack = 30
	current_enemy.defense = 20
	current_enemy.senses = 30
	current_enemy.speed = 40
	current_enemy.installBlueprintByNameAndTier("Claw", 2)
	current_enemy.installBlueprintByNameAndTier("Spot", 2, 2)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Launcher"
	current_enemy.hp = 170
	current_enemy.tech_points = 90
	current_enemy.attack = 50
	current_enemy.defense = 25
	current_enemy.senses = 35
	current_enemy.speed = 30
	current_enemy.installBlueprintByNameAndTier("Missile", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Silo Lord"
	current_enemy.hp = 800
	current_enemy.tech_points = 200
	current_enemy.attack = 30
	current_enemy.defense = 40
	current_enemy.senses = 40
	current_enemy.speed = 25
	current_enemy.support_priority = 1
	current_enemy.installBlueprintByNameAndTier("Missile", 2)
	current_enemy.installBlueprintByNameAndTier("Frag Bomb", 2)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 2)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Tanker"
	current_enemy.hp = 400
	current_enemy.tech_points = 120
	current_enemy.attack = 1
	current_enemy.defense = 30
	current_enemy.senses = 40
	current_enemy.speed = 40
	current_enemy.installBlueprintByNameAndTier("Acid Mist", 2)
	current_enemy.installBlueprintByNameAndTier("Turbo", 2, 0)
	current_enemy.installBlueprintByNameAndTier("Honey", 2, 4)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 1)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	addEnemyToTable(current_enemy)
	
	### CANYON OVERWORLD ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Toxoid"
	current_enemy.hp = 150
	current_enemy.tech_points = 120
	current_enemy.attack = 40
	current_enemy.defense = 40
	current_enemy.senses = 45
	current_enemy.speed = 45
	current_enemy.installBlueprintByNameAndTier("Claw", 2, 2)
	current_enemy.installBlueprintByNameAndTier("Tear Gas", 2)
	current_enemy.installBlueprintByNameAndTier("Numb Gas", 2)
	addEnemyToTable(current_enemy)
	
	### CANYON ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Raptor"
	current_enemy.hp = 150
	current_enemy.tech_points = 160
	current_enemy.attack = 50
	current_enemy.defense = 35
	current_enemy.senses = 80
	current_enemy.speed = 100
	current_enemy.installBlueprintByNameAndTier("Claw", 2, 5)
	current_enemy.installBlueprintByNameAndTier("Acid Mist", 2, 2)
	current_enemy.installBlueprintByNameAndTier("Frag Bomb", 2)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Sniper"
	current_enemy.hp = 800
	current_enemy.tech_points = 300
	current_enemy.attack = 80
	current_enemy.defense = 60
	current_enemy.senses = 130
	current_enemy.speed = 70
	current_enemy.installBlueprintByNameAndTier("Laser", 2)
	current_enemy.installBlueprintByNameAndTier("Bullseye", 2)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 1)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	### MILITARY BASE ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "APU-019"
	current_enemy.hp = 60
	current_enemy.tech_points = 100
	current_enemy.attack = 30
	current_enemy.defense = 15
	current_enemy.senses = 60
	current_enemy.speed = 70
	current_enemy.installBlueprintByNameAndTier("Microwave", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Grenade", 1)
	current_enemy.gives_bio_energy = false
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Prototype"
	current_enemy.hp = 700
	current_enemy.tech_points = 100
	current_enemy.attack = 25
	current_enemy.defense = 45
	current_enemy.senses = 70
	current_enemy.speed = 60
	current_enemy.installBlueprintByNameAndTier("160MM Gun", 1)
	current_enemy.installBlueprintByNameAndTier("8MM MG", 1)
	current_enemy.gives_bio_energy = false
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	# Include a burn-focused boss for a real climax
	
	### SEASIDE OVERWORLD ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Crab"
	current_enemy.hp = 250
	current_enemy.tech_points = 180
	current_enemy.attack = 110
	current_enemy.defense = 100
	current_enemy.senses = 80
	current_enemy.speed = 60
	current_enemy.installBlueprintByNameAndTier("Claw", 2, 2)
	current_enemy.installBlueprintByNameAndTier("Horn", 2)
	current_enemy.installBlueprintByNameAndTier("Mucus", 2)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 2)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	addEnemyToTable(current_enemy)
	
	### NAVAL BASE ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Barnacle"
	current_enemy.hp = 280
	current_enemy.tech_points = 250
	current_enemy.attack = 120
	current_enemy.defense = 140
	current_enemy.senses = 100
	current_enemy.speed = 60
	current_enemy.installBlueprintByNameAndTier("Claw", 2, 2)
	current_enemy.installBlueprintByNameAndTier("Horn", 2)
	current_enemy.installBlueprintByNameAndTier("Mucus", 2)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 2)
	current_enemy.installBlueprintByNameAndTier("Immunity", 1)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "King Crab"
	current_enemy.hp = 900
	current_enemy.tech_points = 800
	current_enemy.attack = 170
	current_enemy.defense = 170
	current_enemy.senses = 110
	current_enemy.speed = 80
	current_enemy.installBlueprintByNameAndTier("Claw", 3)
	current_enemy.installBlueprintByNameAndTier("Horn", 2)
	current_enemy.installBlueprintByNameAndTier("Marshal", 3)
	current_enemy.installBlueprintByNameAndTier("Formation", 3)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 2)
	current_enemy.installBlueprintByNameAndTier("Molt", 2)
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	### SEAFLOOR ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Shark"
	current_enemy.hp = 400
	current_enemy.tech_points = 300
	current_enemy.attack = 140
	current_enemy.defense = 60
	current_enemy.senses = 130
	current_enemy.speed = 140
	current_enemy.installBlueprintByNameAndTier("Claw", 3, 4)
	current_enemy.installBlueprintByNameAndTier("Auto Rifle", 3)
	current_enemy.installBlueprintByNameAndTier("Web", 2)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 2)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	addEnemyToTable(current_enemy)
	
	### LAB ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Pulser"
	current_enemy.hp = 600
	current_enemy.tech_points = 700
	current_enemy.attack = 130
	current_enemy.defense = 80
	current_enemy.senses = 140
	current_enemy.speed = 120
	current_enemy.installBlueprintByNameAndTier("Psy pulse", 3)
	current_enemy.installBlueprintByNameAndTier("Laser", 3)
	current_enemy.installBlueprintByNameAndTier("Molt", 2)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 1)
	current_enemy.installBlueprintByNameAndTier("Immunity", 1)
	current_enemy.support_priority = 2
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Prometheus"
	current_enemy.hp = 2000
	current_enemy.tech_points = 1000
	current_enemy.attack = 160
	current_enemy.defense = 160
	current_enemy.senses = 160
	current_enemy.speed = 160
	current_enemy.installBlueprintByNameAndTier("Laser", 3, 2)
	current_enemy.installBlueprintByNameAndTier("Horn", 3, 2)
	current_enemy.installBlueprintByNameAndTier("Psy pulse", 3, 1)
	current_enemy.installBlueprintByNameAndTier("Missile", 3, 1)
	current_enemy.installBlueprintByNameAndTier("Recombine", 1, 0)
	current_enemy.installBlueprintByNameAndTier("Molt", 3)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 2)
	current_enemy.support_priority = 1
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Dispenser"
	current_enemy.hp = 1500
	current_enemy.tech_points = 1000
	current_enemy.attack = 130
	current_enemy.defense = 130
	current_enemy.senses = 130
	current_enemy.speed = 130
	current_enemy.installBlueprintByNameAndTier("Fire Sweep", 3)
	current_enemy.installBlueprintByNameAndTier("Numb Gas", 3)
	current_enemy.installBlueprintByNameAndTier("Acid Mist", 3)
	current_enemy.installBlueprintByNameAndTier("Tear Gas", 3)
	current_enemy.installBlueprintByNameAndTier("Web", 3)
	current_enemy.installBlueprintByNameAndTier("Rage Gas", 3)
	current_enemy.installBlueprintByNameAndTier("Molt", 2)
	current_enemy.installBlueprintByNameAndTier("Immunity", 1)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 2)
	addEnemyToTable(current_enemy)
	
	### ZENITH ###
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Zenith"
	current_enemy.hp = 4095
	current_enemy.tech_points = 1200
	current_enemy.attack = 200
	current_enemy.defense = 200
	current_enemy.senses = 200
	current_enemy.speed = 200
	current_enemy.installBlueprintByNameAndTier("Laser", 3)
	current_enemy.installBlueprintByNameAndTier("Missile", 3)
	current_enemy.installBlueprintByNameAndTier("Psy pulse", 3)
	current_enemy.installBlueprintByNameAndTier("Fire Sweep", 3)
	current_enemy.installBlueprintByNameAndTier("Acid Mist", 3)
	current_enemy.installBlueprintByNameAndTier("FusionBomb", 1)
	current_enemy.installBlueprintByNameAndTier("Mind Rip", 1)
	current_enemy.installBlueprintByNameAndTier("Crush", 1)
	current_enemy.installBlueprintByNameAndTier("Bud", 1)
	current_enemy.installBlueprintByNameAndTier("Perfect", 1, 2)
	current_enemy.installBlueprintByNameAndTier("Molt", 3)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 3)
	current_enemy.installBlueprintByNameAndTier("1stStrike", 1)
	current_enemy.installBlueprintByNameAndTier("Immunity", 2)
	current_enemy.gives_bio_energy = false
	current_enemy.support_priority = 1
	current_enemy.is_boss = true
	addEnemyToTable(current_enemy)
	
	current_enemy = EnemyType.new()
	current_enemy.name = "Z-Spawn"
	current_enemy.hp = 500
	current_enemy.tech_points = 800
	current_enemy.attack = 150
	current_enemy.defense = 100
	current_enemy.senses = 120
	current_enemy.speed = 120
	current_enemy.installBlueprintByNameAndTier("Claw", 3)
	current_enemy.installBlueprintByNameAndTier("Missile", 3)
	current_enemy.installBlueprintByNameAndTier("Psy pulse", 3)
	current_enemy.installBlueprintByNameAndTier("Fire Sweep", 3)
	current_enemy.installBlueprintByNameAndTier("Molt", 1)
	current_enemy.installBlueprintByNameAndTier("Hydrocoat", 1)
	current_enemy.installBlueprintByNameAndTier("Immunity", 1)
	current_enemy.gives_bio_energy = false
	addEnemyToTable(current_enemy)


static func getEnemyByName(name_in: String) -> EnemyType:
	if table.has(name_in):
		return table[name_in]
	push_error("Tried to get nonexistent enemy from table: " + name_in)
	return null


static func addEnemyToTable(enemy: EnemyType):
	table[enemy.name] = enemy


# Given an array of enemy names, build an array of their corresponding enemy types
static func buildEnemyList(enemy_names: Array[String]) -> Array[EnemyType]:
	var result: Array[EnemyType] = []
	for enemy_name in enemy_names:
		result.append(getEnemyByName(enemy_name))
	return result
