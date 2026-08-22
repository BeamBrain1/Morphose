extends DialogBox

signal slots_changed

var assigned_party_member: PartyMember

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func assignPartyMember(party_member: PartyMember) -> void:
	assigned_party_member = party_member
	updateDisplay()


func updateDisplay() -> void:
	$LabelCurrentSlots.text = "CURRENT SLOTS: " + str(assigned_party_member.blueprint_slots)
	if not assigned_party_member.atMaxBlueprintSlots():
		$LabelExpansionCostHeader.text = "TO ADD: " + str(assigned_party_member.mutaCostToAddBlueprintSlot()) + "M"
	else:
		$LabelExpansionCostHeader.text = "MAXED"
	$ButtonAddSlot.disabled = not assigned_party_member.canAddBlueprintSlot()
	$ButtonRemoveSlot.disabled = not assigned_party_member.canRemoveBlueprintSlot()


func _on_button_add_slot_pressed() -> void:
	assigned_party_member.addBlueprintSlot()
	updateDisplay()
	emit_signal("slots_changed")


func _on_button_remove_slot_pressed() -> void:
	assigned_party_member.removeBlueprintSlot()
	updateDisplay()
	emit_signal("slots_changed")
