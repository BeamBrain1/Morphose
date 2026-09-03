extends Node2D

signal tab_selected_window
signal tab_selected_character
signal reset
signal save
signal cancel


func _ready() -> void:
	$DialogInfoPanel.displayText("PLACEHOLDER")


func loadPartyMemberList(list: Array[PartyMember]) -> void:
	$DialogCharacterSelect.buildSelectableCharacterList(list)


func loadPartyMember(party_member: PartyMember) -> void:
	$DialogMutaCount.setMutaCount(party_member.bio_energy)
	$DialogExitScreen/ButtonReset.disabled = false	# Once a party member has been loaded, we can reset their stats


func tabSelectedWindow(button_name: String) -> void:
	emit_signal("tab_selected_window", button_name)


func tabSelectedCharacter(button_name: String) -> void:
	emit_signal("tab_selected_character", button_name)


func _on_button_reset_pressed() -> void:
	emit_signal("reset")


func _on_button_save_pressed() -> void:
	emit_signal("save")


func _on_button_cancel_pressed() -> void:
	emit_signal("cancel")
