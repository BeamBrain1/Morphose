extends MapScript


func body() -> void:
	if isFlagSet("SecurityAmbushDefeated"):
		await destroyActiveObject("SecurityNPC1")
		await destroyActiveObject("SecurityNPC2")
	else:
		await displayDialog("Security", "How did it get this far? ...You! Worker! You've been helping it! We'll kill you too!")
		for i in range(3):
			pushActor("SecurityNPC1", 1, GlobalProgramData.DIRECTION.UP)
			pushActor("SecurityNPC2", 1, GlobalProgramData.DIRECTION.UP)
			await delay(DEFAULT_STEP_DELAY)
		await setFlag("SecurityAmbushDefeated")
		await doEncounter(["Security", "Security"])
		if battle_won:
			await displayDialog("Defector", "Starting to think we can pull this off! South door leads to the armory. Probably has good combat blueprints.")
