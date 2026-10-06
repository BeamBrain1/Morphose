extends MapScript


func body() -> void:
	if isFlagSet("OverseerKilled"):
		destroyActiveObject("OverseerNPC")
