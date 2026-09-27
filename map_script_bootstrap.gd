extends MapScript


func body() -> void:
	if not isFlagSet("PrimusBootstrapped"):
		await giveMuta(20, "Primus")
		await giveBlueprint("Claw")
		await setFlag("PrimusBootstrapped")
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Scanning...\nSubject Morphose has no configured combat capabilities. Running standard bootstrap program.")
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Supplying attack schematic: CLAW.\nPerforming standard Muta injection...\nProcess complete.")
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Opening Muta allocation interface. You may now install CLAW. Additional Muta obtained may be used to install other acquired blueprints or boost combat performance.")
	await openCharBuildScreen(true)
