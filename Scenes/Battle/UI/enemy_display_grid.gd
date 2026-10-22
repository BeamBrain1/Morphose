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
	
	var enemy_status_display = EnemyStatusDisplay.instantiate()
	enemy_status_display.assignCombatant(combatant)
	
	# This is a special condition: by default, a large enemy takes up a "middle" slot, leaving no room for a second.
	# If this condition is detected, the large enemy is first shunted to slot 0, which opens room for the second enemy
	if enemy_status_display.isLargeSprite() and enemy_status_displays.size() == 1 and enemy_status_displays[0].isLargeSprite():
		assignSlot(enemy_status_displays[0], 0)

	if slotAvailable(enemy_status_display):
		add_child(enemy_status_display)
		assignSlot(enemy_status_display)
		enemy_status_displays.append(enemy_status_display)
		enemy_status_display.select_combatant.connect(selectCombatantAsTarget)
	else:	# We can't add this as a new enemy, so un-instantiate the display and attempt to write over an existing display
		enemy_status_display.call_deferred("queue_free")
		for display in enemy_status_displays:
			if display.enemy.isDefeated():
				display.assignCombatant(combatant)
				break


# Assign an enemy a slot and update its display display position based on the slot
# force_slot: Optional parameter to force an enemy into a specific slot
func assignSlot(display: EnemyDisplay, force_slot: int = -1) -> void:
	if force_slot != -1:
		display.slot = force_slot
	else:
		display.slot = nextFreeSlot(display)
	display.position = FIRST_ENEMY_DISPLAY_POSITION + Vector2((display.slot % 4) * NEXT_ENEMY_DISPLAY_OFFSET_X, floor(display.slot / 4) * NEXT_ENEMY_DISPLAY_OFFSET_Y)
	if display.isLargeSprite():
		display.position += display.LARGE_SPRITE_OFFSET


# Returns the next free slot for this display in descending order of priority or -1 if none available
func nextFreeSlot(display: EnemyDisplay) -> int:
	var check_slot_array: Array[int]
	if display.isLargeSprite():
		check_slot_array = DISPLAY_SLOT_PRIORITY_LARGE_SIZE
	else:
		check_slot_array = DISPLAY_SLOT_PRIORITY_DEFAULT_SIZE
		
	for check_slot in check_slot_array:		# Iterate through slots in decreasing priority
		var required_slots = occupiedSlots(display, check_slot)	# How many slots does this display need?
		var all_slots_available: bool = true
		for occupied_slot in allOccupiedSlots():
			if occupied_slot in required_slots:
				all_slots_available = false
				break
		if all_slots_available:
			return check_slot
	return -1	# No free slot found


# Returns a list of slots that have already been taken by other enemies
func allOccupiedSlots() -> Array[int]:
	var result: Array[int] = []
	for display in enemy_status_displays:
		result += occupiedSlots(display)
	return result


# Indicates whether there is a lot available for the supplied enemy status display
func slotAvailable(display: EnemyDisplay) -> bool:
	return nextFreeSlot(display) != -1


# List the slots an enemy display occupies or would occupy on the battle grid
# display: The display to check
# slot: The slot to check. By default it is -1, which checks the enemy's currently assigned slot
# A normal-sized enemy will take only its slot number; a large enemy takes additional slots (a 2x2 grid starting at its own position)
func occupiedSlots(display: EnemyDisplay, slot: int = -1) -> Array[int]:
	var slot_to_check: int
	if slot == -1:
		slot_to_check = display.slot
	else:
		slot_to_check = slot
	if display.isLargeSprite():
		return [slot_to_check, slot_to_check+1, slot_to_check+ENEMIES_PER_ROW, slot_to_check+1+ENEMIES_PER_ROW]
	else:
		return [slot_to_check]


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
