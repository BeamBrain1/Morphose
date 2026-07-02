extends DialogBox


func _ready() -> void:
	for node in getPartyMemberButtons():
			node.hide()


func buildSelectableCharacterList(party_members: Array[PartyMember]) -> void:
	for button in getPartyMemberButtons():
		if characterNameInCharacterList(button.getButtonText(), party_members):
			button.show()


func characterNameInCharacterList(name_in: String, party_members: Array[PartyMember]) -> bool:
	for member in party_members:
		if $Body/TabHeaderList.hasButtonWithName(name_in):
			return true
	return false


func getPartyMemberButtons() -> Array:
	return $Body/TabHeaderList.tab_header_buttons
