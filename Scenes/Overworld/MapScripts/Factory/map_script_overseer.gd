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
