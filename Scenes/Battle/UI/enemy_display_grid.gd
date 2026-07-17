extends Node2D

@export var EnemyStatusDisplay: PackedScene
var enemy_status_displays: Array

const FIRST_ENEMY_DISPLAY_POSITION: Vector2 = Vector2(24, 16)
const NEXT_ENEMY_DISPLAY_OFFSET_X: int = 80
const NEXT_ENEMY_DISPLAY_OFFSET_Y: int = 48
const ENEMIES_PER_ROW: int = 4
const MAX_ENEMIES: int = 8

signal combatant_selected

var max_enemy_with_base_name: Dictionary = {}

func selectCombatantAsTarget(combatant: EnemyCombatant) -> void:
	emit_signal("combatant_selected", combatant)


func assignEnemyStatusDisplaysFromList(enemy_types: Array) -> void:
	for display in enemy_status_displays:
		display.call_deferred("queue_free")
	enemy_status_displays = []
	for enemy_type in enemy_types:
		addEnemy(enemy_type)


	# If display grid is not full, append enemy to end.
	# If display grid is full, replace a defeated enemy.
	# If grid full and no defeated enemy to replace, do not add enemy.
func addEnemy(type: EnemyType) -> void:
	
	var combatant = EnemyCombatant.new(type)
	
	if max_enemy_with_base_name.has(combatant.name):
		max_enemy_with_base_name[combatant.name] += 1
	else:
		max_enemy_with_base_name[combatant.name] = 1

	combatant.number_in_battle = max_enemy_with_base_name[combatant.name]
	
	if not battleGridIsFull():
		var enemy_status_display = EnemyStatusDisplay.instantiate()
		enemy_status_display.assignCombatant(combatant)
		add_child(enemy_status_display)
		enemy_status_display.position = FIRST_ENEMY_DISPLAY_POSITION + Vector2((enemy_status_displays.size() % 4) * NEXT_ENEMY_DISPLAY_OFFSET_X, floor(enemy_status_displays.size() / 4) * NEXT_ENEMY_DISPLAY_OFFSET_Y)
		enemy_status_displays.append(enemy_status_display)
		enemy_status_display.select_combatant.connect(selectCombatantAsTarget)
	else:
		for display in enemy_status_displays:
			if display.enemy.isDefeated():
				display.assignCombatant(combatant)
				break


func battleGridIsFull() -> bool:
	return enemy_status_displays.size() == MAX_ENEMIES


func updateEnemyStatusDisplays() -> void:
	for display in enemy_status_displays:
		display.updateDisplay()


func activateAttackTargetButtons() -> void:
	for display in enemy_status_displays:
		display.enableTargetingIfEnemyAlive()


func deactivateAttackTargetButtons() -> void:
	for display in enemy_status_displays:
		display.disableTargeting()


func getEnemyCombatants() -> Array[EnemyCombatant]:
	var result: Array[EnemyCombatant] = []
	for display in enemy_status_displays:
		result.append(display.enemy)
	return result


func getTotalBioEnergyReward() -> int:
	var result: int = 0
	for display in enemy_status_displays:
		result += display.enemy.getBioEnergyReward()
	return result
