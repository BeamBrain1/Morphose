extends MapScript


func body() -> void:
	await delay(0.5)
	await turnNPC("TestNPC", GlobalProgramData.DIRECTION.RIGHT)
	await delay(1)
	await turnNPC("TestNPC", GlobalProgramData.DIRECTION.LEFT)
	await delay(1)
	await pushActiveObject("TestNPC", 3, GlobalProgramData.DIRECTION.RIGHT)
	await delay(1)
	await pushActiveObject("TestNPC", 3, GlobalProgramData.DIRECTION.LEFT, 0.5)
	await displayDialog("Patrol", "Hey, you're not supposed to be here!")
	await doEncounter(["Livestock"])
	await displayDialog("Patrol", "Oh no, I'm dead!")
	destroyActiveObject("TestNPC")
