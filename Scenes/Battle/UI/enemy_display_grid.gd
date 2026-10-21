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

# Indicates the order in which to fill enemy display slots
# Slots are oriented on the screen as follows:
#	0 1 2 3
#	4 5 6 7
# This order prioritizes slots closer to the center
const DISPLAY_SLOT_PRIORITY_DEFAULT_SIZE: Array[int] = [1, 2, 5, 6, 0, 4, 3, 7]
# Large enemies can only be displayed in the top row, and not on the furthest right edge
const DISPLAY_SLOT_PRIORITY_LARGE_SIZE: Array[int] = [1, 0, 2]

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
	
	if max_enemy_with_base_name.has(combatant.getName()):
		max_enemy_with_base_name[combatant.getName()] += 1
	else:
		max_enemy_with_base_name[combatant.getName()] = 1

	combatant.number_in_battle = max_enemy_with_base_name[combatant.getName()]
	
	if not battleGridIsFull():
		var enemy_status_display = EnemyStatusDisplay.instantiate()
		enemy_status_display.assignCombatant(combatant)
		add_child(enemy_status_display)
		assignSlot(enemy_status_display)
		enemy_status_displays.append(enemy_status_display)
		enemy_status_display.select_combatant.connect(selectCombatantAsTarget)
	else:
		for display in enemy_status_displays:
			if display.enemy.isDefeated():
				display.assignCombatant(combatant)
				break


# Assign an enemy a slot and update its display display position based on the slot
func assignSlot(display: EnemyDisplay) -> void:
	display.slot = nextFreeSlot()
	display.position = FIRST_ENEMY_DISPLAY_POSITION + Vector2((display.slot % 4) * NEXT_ENEMY_DISPLAY_OFFSET_X, floor(display.slot / 4) * NEXT_ENEMY_DISPLAY_OFFSET_Y)


# Returns the next free slot in descending order of priority or -1 if none available
func nextFreeSlot() -> int:	
	for slot in DISPLAY_SLOT_PRIORITY_DEFAULT_SIZE:		# Iterate through slots in decreasing priority
		if not slot in takenSlots():					# Free slot found
			return slot
	return -1	# No free slot found


# Returns a list of slots that have already been taken by other enemies
func takenSlots() -> Array[int]:
	var result: Array[int] = []
	for display in enemy_status_displays:
		result += singleDisplayTakenSlots(display)
	return result


# Returns the slot(s) taken by an enemy status display
# A normal-sized enemy will take only its slot number; a large enemy takes additional slots (a 2x2 grid starting at its own position
func singleDisplayTakenSlots(display: EnemyDisplay) -> Array[int]:
	if display.isLargeSprite():
		return [display.slot, display.slot+1, display.slot+ENEMIES_PER_ROW, display.slot+1+ENEMIES_PER_ROW]
	return [display.slot]


func battleGridIsFull() -> bool:
	return nextFreeSlot() == -1


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
	for combatant in getEnemyCombatants():
		result += combatant.getBioEnergyReward()
	return result


func getEnemyCatchPoints() -> int:
	var result = 0
	for combatant in getEnemyCombatants():
		result += combatant.catchPoints()
	return result


func encounterHasBoss() -> bool:
	for combatant in getEnemyCombatants():
		if combatant.isBoss():
			return true
	return false


# Player can always run from an encounter if only living enemies are flagged as run always succeeding
# encounterHasBoss() prevents running and takes priority over this
func canAlwaysRunFromEncounter() -> bool:
	if encounterHasBoss():
		return false
	for combatant: EnemyCombatant in getEnemyCombatants():
		if not (combatant.isDefeated() or combatant.morphose.run_from_attempts_always_succeed):
			return false
	return true


func getCombatantDisplay(enemy) -> EnemyDisplay:
	for display in enemy_status_displays:
		if display.enemy == enemy:
			return display
	push_error("Enemy display not found: " + str(enemy))
	return null


func eatEnemies():
	for enemy in enemy_status_displays:
		await enemy.getEaten()
