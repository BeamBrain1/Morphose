extends MapScript


func body() -> void:
	if not isFlagSet("DefectorJoined"):
		var defector_npc: String = "DefectorNPC"
		await spawnActiveObject("NPCs/Factory/Defector", defector_npc, Vector2(22, 1))
		await turnNPC(defector_npc, GlobalProgramData.DIRECTION.RIGHT)
		await delay(1)
		if activeMap().gridPosition(activeMap().getPartyToken()).x == 23:
			await pushParty(1, GlobalProgramData.DIRECTION.LEFT)
			await turnParty(GlobalProgramData.DIRECTION.UP)
		await displayDialog("Primus", "!")
		await pushParty(1, GlobalProgramData.DIRECTION.UP)
		await delay(0.25)
		await turnNPC(defector_npc, GlobalProgramData.DIRECTION.DOWN)
		await delay(0.25)
		await displayDialog("Worker", "Wait! Don't eat me!")
		pushParty(1, GlobalProgramData.DIRECTION.UP)
		await delay(0.25)
		await pushActor(defector_npc, 1, GlobalProgramData.DIRECTION.UP, DEFAULT_STEP_DELAY, false)
		await displayDialog("Worker", "Listen to me, you brute! I want to HELP you! You can't escape this facility without me!")
		await delay(1)
		await displayDialog("Primus", "...?")
		await displayDialog("Worker", "Good. Pay attention. This place's Overseer is tough. He's harvested Muta from guys like you for years.")
		await displayDialog("Worker", "You can't beat him alone. But I've wanted to escape this place for a while too. Together, we have a chance.")
		await displayDialog("Worker", "They were going to eat me, too - that's what they do to chronic underpeformers.")
		await displayDialog("Worker", "I raided the Muta stores, so I can handle myself in a fight. But I want a cut of the harvests.")
		await displayDialog("Worker", "My worker designation is J-427, but you can call me Defector.")
		await displayDialog("Defector", "Oh, one more thing. I grabbed a Honey blueprint. It heals wounds. You can't use it - incompatible with your body.")
		await displayDialog("Defector", "I can use it, though. Didn't have time to install it, so we should take care of that now.")
		await addPartyMember("Defector")
		await giveBlueprint("Honey")
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Defector joined.\nGained genetic blueprint for Honey.")
		await openCharBuildScreen(false)
		await spawnActiveObject("NPCs/Factory/Defector_NPC", defector_npc, Vector2(23, 20))
		await displayDialog("Defector", "All set? Good. Let's get out of here!")
		await destroyActiveObject(defector_npc)
		await setFlag("DefectorJoined")
