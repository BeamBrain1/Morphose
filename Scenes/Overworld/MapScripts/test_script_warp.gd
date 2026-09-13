extends MapScript


func body() -> void:
	await displayDialog("Primus", "Let's warp!")
	await warpTo("TestMap2", Vector2(2, 6))
	await displayDialog("Scholar", "That made me physically ill. Let's never do that again.")
	await displayDialog("Defector", "No kidding.")
