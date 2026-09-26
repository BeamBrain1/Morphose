extends MapScript


func body() -> void:
	await doEncounter(["Livestock"])
	if isFlagSet("FarmPanelLoosened"):
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "The fighting knocked the loose wall panel off its hinges.")
		await setFlag("FarmPanelLoosened")
	if battle_won:
		await setFlag(holder + "Killed")
		await destroyActiveObject(holder)
