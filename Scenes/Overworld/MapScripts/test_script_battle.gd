extends MapScript


func body() -> void:
	await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "It's time to d-d-d-d-duel!")
	await doEncounter(["Livestock"])
	await displayDialog("Primus", "Nothing to it.")
