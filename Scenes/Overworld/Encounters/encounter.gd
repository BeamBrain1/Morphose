class_name Encounter
extends Node

@export var enemy_list: Array	# String of enemy names
@export var weight: int


func getEnemies() -> Array: # Array of EnemyType
	var result = []
	for enemy in enemy_list:
		result.append(EnemyTable.getEnemyByName(enemy))
	return result


# EnemyTable: static func getEnemyByName(name_in: String) -> EnemyType:
