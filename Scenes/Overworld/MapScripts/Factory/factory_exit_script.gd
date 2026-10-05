extends MapScript


func body() -> void:
	if isFlagSet("OverseerKilled"):
		destroyActiveObject("NPCOverseer")
		await displayDialog("Defector", "...We did it.")
		await displayDialog("Defector", "We actually did it! We're free! We never have to see this place again! Aren't you glad you didn't eat me?")
		await displayDialog("Defector", "I've... never left the factory. I don't know what's out there. But anywhere's better than here, right?")
		await displayDialog("Defector", "Overseer once mentioned a \"city\" to the north. Tougher Morphose there. Better food, more Muta.")
		await displayDialog("Defector", "You and me, Primus! We're moving up in the world!")
