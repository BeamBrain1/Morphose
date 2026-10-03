extends MapScript


func body() -> void:
	await displayDialog(PartyMember.PARTY_MEMBER_DEFECTOR_NAME, "I'm joining!")
	await addPartyMember(PartyMember.PARTY_MEMBER_DEFECTOR_NAME)
