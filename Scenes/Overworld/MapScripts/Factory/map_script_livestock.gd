extends MapScript


func body() -> void:
	if GlobalProgramData.DEBUG_MODE:
		await doEncounter(["Livestock"])
	else:
		await doEncounter(["Livestock"])
	if not isFlagSet("FarmPanelLoosened"):
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "The fighting knocked the loose wall panel out of its frame.")
		await setFlag("FarmPanelLoosened")
		await destroyActiveObject("LoosePanel")
	if battle_won:
		await setFlag(holder + "Killed")
		await destroyActiveObject(holder)
