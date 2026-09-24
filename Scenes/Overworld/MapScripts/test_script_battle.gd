extends MapScript


func body() -> void:
	await doEncounter(["Livestock"])
	await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Post-battle script")
