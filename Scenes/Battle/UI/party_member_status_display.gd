extends Node2D

var combatant: PartyCombatant
const MAX_DIGITS: int = 3

const ALIVE_TEXT_COLOR = Color(1, 1, 1, 1)
const DEFEATED_TEXT_COLOR = Color(0.666, 0.666, 0.666, 1)

signal select_as_support_target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Labels/LabelName.text = combatant.getName().to_upper()
	$ButtonSelectAsTarget.hide()
	$TurnIndicator.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func assignCombatant(combatant_in: PartyCombatant):
	combatant = combatant_in
	updateStatusDisplay()


func updateStatusDisplay() -> void:
	updateHPDisplay()
	updateTPDisplay()
	updateTPRegenDisplay()
	updateStatusEffectsDisplay()
	if combatant.isDefeated():
		$Labels.modulate = DEFEATED_TEXT_COLOR
	else:
		$Labels.modulate = ALIVE_TEXT_COLOR


func updateHPDisplay() -> void:
	$Labels/LabelHP.text = str(combatant.hp).lpad(MAX_DIGITS) + "/" + str(combatant.getMaxHP()).lpad(MAX_DIGITS)


func updateTPDisplay() -> void:
	$Labels/LabelTP.text = str(combatant.tech_points).lpad(MAX_DIGITS) + "/" + str(combatant.getMaxTP()).lpad(MAX_DIGITS)


func updateTPRegenDisplay() -> void:
	$Labels/LabelTPRegen.text = "(+" + str(combatant.getStatusEffectAdjustedTPRegen()) + ")"


func updateStatusEffectsDisplay() -> void:
	$RegenDisplay.updateDisplay(combatant.regen_stacks)
	$FocusedDisplay.updateDisplay(combatant.focused_stacks)
	$SharpenedDisplay.updateDisplay(combatant.sharpened_stacks)
	$HardenedDisplay.updateDisplay(combatant.hardened_stacks)
	$KeenDisplay.updateDisplay(combatant.keen_stacks)
	$EnergizedDisplay.updateDisplay(combatant.energized_stacks)


func activateTargetSelection(blueprint: BlueprintSupport) -> void:
	if combatant.isValidSupportTarget(blueprint):
		showEnabledTargetSelection()
	else:
		showDisabledTargetSelection()

func showEnabledTargetSelection() -> void:
	$ButtonSelectAsTarget.show()
	$ButtonSelectAsTarget.disabled = false


func showDisabledTargetSelection() -> void:
	$ButtonSelectAsTarget.show()
	$ButtonSelectAsTarget.disabled = true


func disableTargetSelection() -> void:
	$ButtonSelectAsTarget.hide()
	$ButtonSelectAsTarget.disabled = true


func _on_button_select_as_target_pressed() -> void:
	emit_signal("select_as_support_target", combatant)


func toggleTurnIndicator(combatant_in: Combatant) -> void:
	if combatant == combatant_in:
		$TurnIndicator.show()
	else:
		$TurnIndicator.hide()
