extends MapScript


func body() -> void:
	
	var gatekeeper_npc: String = "GatekeeperWorkerNPC"
	
	if isFlagSet("GatekeeperWorkerKilled"):
		await destroyActiveObject(gatekeeper_npc)
	else:
		await delay(1)
		await turnNPC(gatekeeper_npc, GlobalProgramData.DIRECTION.UP)
		await delay(0.5)
		await displayDialog("Worker", "You! Get back in your pen!")
		await pushActor(gatekeeper_npc, 3, GlobalProgramData.DIRECTION.UP)
		await setFlag("GatekeeperWorkerKilled")
		await doEncounter(["Worker"])
		if battle_won:
			await destroyActiveObject(gatekeeper_npc)
			await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "\"Escape! A livestock escaped, and it has a weapon blueprint!\"")
			await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "\"Vacate your stations and tell the security caste!\"")
		else:
			await clearFlag("GateKeeperWorkerKilled")
			await warpTo("FactoryPens", Vector2(0, 0))
