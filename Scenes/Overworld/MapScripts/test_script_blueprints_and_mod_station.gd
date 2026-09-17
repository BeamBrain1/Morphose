extends MapScript


func body() -> void:
	await giveBlueprint("Laser", 1)
	await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Got Laser blueprint.")
	await displayDialog(PartyMember.PARTY_MEMBER_PRIMUS_NAME, "I'm gonna install it!")
	await openCharBuildScreen(true)
	await displayDialog(PartyMember.PARTY_MEMBER_PRIMUS_NAME, "That was fun.")
