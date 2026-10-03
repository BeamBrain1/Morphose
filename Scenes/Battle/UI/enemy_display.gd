extends Button

var enemy: EnemyCombatant

signal select_combatant

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disabled = true
	$LabelName.hide()


func assignCombatant(enemy_in: EnemyCombatant) -> void:
	enemy = enemy_in
	show()
	$LabelName.text = enemy.getName().to_upper()
	if $LabelName.text.length() % 2 == 1:
		$LabelName.text += " "	# Since label centered, even number of characters necessary to align text to grid
	updateDisplay()


func enableTargetingIfEnemyAlive():
	if not enemy.isDefeated():
		disabled = false


func disableTargeting():
	disabled = true


func updateDisplay():
	if enemy.isDefeated():
		hide()
		disableTargeting()
	else:
		updateStatusDisplays()


func _on_pressed() -> void:
	emit_signal("select_combatant", enemy)


func _on_mouse_entered() -> void:
	if not enemy.isDefeated():
		$LabelName.show()


func _on_mouse_exited() -> void:
	$LabelName.hide()


func updateStatusDisplays():
	$StatusEffectDisplays/Regen.updateDisplay(enemy.regen_stacks)
	$StatusEffectDisplays/Focused.updateDisplay(enemy.focused_stacks)
	$StatusEffectDisplays/Sharpened.updateDisplay(enemy.sharpened_stacks)
	$StatusEffectDisplays/Hardened.updateDisplay(enemy.hardened_stacks)
	$StatusEffectDisplays/Keen.updateDisplay(enemy.keen_stacks)
	$StatusEffectDisplays/Energized.updateDisplay(enemy.energized_stacks)
