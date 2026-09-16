extends MapScript


func body() -> void:
	await displayDialog(PartyMember.PARTY_MEMBER_DEFECTOR_NAME, "Screw this, I'm leaving!")
	await removePartyMember(PartyMember.PARTY_MEMBER_DEFECTOR_NAME)
