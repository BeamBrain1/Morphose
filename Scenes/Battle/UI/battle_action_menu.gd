extends Node2D

signal attack
signal support
signal wait
signal run

const ATTACK_SELECTOR_Y_POSITION = 24
const SUPPORT_SELECTOR_Y_POSITION = -48

var active_submenu

signal choose_blueprint

@export var BattleBlueprintSelector: PackedScene


func _on_attack_pressed() -> void:
	emit_signal("attack")


func _on_support_pressed() -> void:
	emit_signal("support")


func _on_wait_pressed() -> void:
	if active_submenu != null:
		closeActiveSubmenu()
	emit_signal("wait")


func _on_run_pressed() -> void:
	if active_submenu != null:
		closeActiveSubmenu()
	emit_signal("run")


func disable():
	closeActiveSubmenu()
	for button in $Buttons.get_children():
		button.disabled = true


func enableUseableButtons(combatant):
	$Buttons/Attack.disabled = not combatant.canAttack()
	$Buttons/Support.disabled = not combatant.canSupport()
	$Buttons/Wait.disabled = false
	$Buttons/Run.disabled = false


func displayAttackMenu(combatant) -> void:
	if active_submenu != null:
		closeActiveSubmenu()
	var battle_blueprint_selector = BattleBlueprintSelector.instantiate()
	battle_blueprint_selector.expands_down = true	# Expand down so player can see enemies
	add_child(battle_blueprint_selector)
	battle_blueprint_selector.position.y = ATTACK_SELECTOR_Y_POSITION
	battle_blueprint_selector.assignBlueprintList(combatant.morphose.blueprints_attack, combatant.tech_points)
	active_submenu = battle_blueprint_selector
	active_submenu.choose_blueprint.connect(chooseBlueprint)
	active_submenu.cancel.connect(closeActiveSubmenu)


func displaySupportMenu(combatant) -> void:
	if active_submenu != null:
		closeActiveSubmenu()
	var battle_blueprint_selector = BattleBlueprintSelector.instantiate()
	battle_blueprint_selector.expands_down = false	# Expand up so player can see party members
	add_child(battle_blueprint_selector)
	battle_blueprint_selector.position.y = SUPPORT_SELECTOR_Y_POSITION
	battle_blueprint_selector.assignBlueprintList(combatant.blueprints_support, combatant.tech_points)
	active_submenu = battle_blueprint_selector
	active_submenu.choose_blueprint.connect(chooseBlueprint)
	active_submenu.cancel.connect(closeActiveSubmenu)


func closeActiveSubmenu() -> void:
	if active_submenu != null:
		active_submenu.call_deferred("queue_free")
		active_submenu = null


func chooseBlueprint(blueprint) -> void:
	emit_signal("choose_blueprint", blueprint)
	closeActiveSubmenu()
