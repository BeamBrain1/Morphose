extends MapScript


func body() -> void:
	if isFlagSet("test"):
		await displayDialog("Scholar", "Wait, we've already done this routine!")
	else:
		await displayDialog("Primus", "Rar I am Primus food food eat Muta")
		await displayDialog("Defector", "I am the Defector, and I want to get ahead by any means.")
		await pushParty(5, GlobalProgramData.DIRECTION.LEFT)
		await pushParty(5, GlobalProgramData.DIRECTION.RIGHT, 0.4)
		await pushActiveObject("ModificationStation", 3, GlobalProgramData.DIRECTION.UP)
		await pushActiveObject("ModificationStation", 3, GlobalProgramData.DIRECTION.DOWN, 0.5)
		await delay(2)
		await displayDialog("Scholar", "I am these idiots' babysitter, apparently.")
		setFlag("test")
