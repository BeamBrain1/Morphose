extends MapScript


func body() -> void:
	await displayDialog("Overseer", "So, the lamb grows a fang and thinks itself a wolf. You've thrown my entire factory into disarray.")
	await displayDialog("Overseer", "Yet something may be salvaged of this. A rich bounty of Muta has delivered itself straight to my jaws.")
	await displayDialog("Overseer", "And J-427. The slacker. I had planned to harvest you today. Your treason has only shortened the time table.")
	await displayDialog("Defector", "Would've worked harder if you'd paid me more. Watch what I can do with a nice, fat payout in front of me!")
	await doEncounter(["Overseer"])
	if battle_won:
		await destroyActiveObject(holder)
		await setFlag("OverseerKilled")
		await displayDialog("Defector", "...We did it.")
		await displayDialog("Defector", "We actually did it! We're free! We never have to see this place again! Aren't you glad you didn't eat me?")
		await displayDialog("Defector", "I've... never left the factory. I don't know what's out there. But anywhere's better than here, right?")
		await displayDialog("Defector", "Overseer once mentioned a \"city\" to the north. Tougher Morphose there. Better food, more Muta.")
		await displayDialog("Defector", "You and me, Primus! We're moving up in the world!")
