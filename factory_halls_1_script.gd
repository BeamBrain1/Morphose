extends MapScript


func body() -> void:
	
	var gatekeeper_npc: String = "GatekeeperWorkerNPC"
	var defector_npc: String = "DefectorNPC"
	
	if isFlagSet("GatekeeperWorkerKilled"):
		await destroyActiveObject(gatekeeper_npc)
	else:
		await delay(1)
		await turnNPC(gatekeeper_npc, GlobalProgramData.DIRECTION.UP)
		await delay(0.5)
		await displayDialog("Worker", "You! Get back in your pen!")
		await pushActor(gatekeeper_npc, 3, GlobalProgramData.DIRECTION.UP)
		await doEncounter(["Worker"])
		if battle_won:
			await setFlag("GatekeeperWorkerKilled")
			await destroyActiveObject(gatekeeper_npc)
		else:
			await warpTo("FactoryPens", Vector2(0, 0))
	if isFlagSet("EnteredFactoryHallsFromWorkerQuartersEast") and not isFlagSet("DefectorJoined"):
		await displayDialog("Worker", "Wait! Don't eat me!")
		await displayDialog("Worker", "Listen to me, you brute! I want to HELP you! You can't escape this facility without me!")
		await displayDialog("Worker", "Good. Pay attention. This place's Overseer is tough. He's harvested Muta from guys like you for years.")
		await displayDialog("Worker", "You can't beat him alone. But I've wanted to escape this place for a while too. Together, we have a chance.")
		await displayDialog("Worker", "They were going to eat me, too - that's what they do to chronic underpeformers.")
		await displayDialog("Worker", "I raided the Muta stores, so I can handle myself in a fight. But I want a cut of the harvests.")
		await displayDialog("Worker", "One more thing. I grabbed a Honey blueprint. It heals wounds. You can't use it - incompatible with your body.")
		await displayDialog("Worker", "I can use it, though. Didn't have time to install it, so we should take care of that now.")
		await addPartyMember("Defector")
		await giveBlueprint("Honey")
		await openCharBuildScreen(false)
		await displayDialog("Worker", "All set? Good. My worker designation is J-427, but you can call me Defector. Let's get out of here!")
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Defector joined.\nGained genetic blueprint for Honey.")
		await destroyActiveObject("DefectorNPC")
		await setFlag("DefectorJoined")
	else:
		await destroyActiveObject("DefectorNPC")
