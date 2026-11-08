extends MapScript


func body() -> void:
	
	var gatekeeper_npc: String = "GatekeeperWorkerNPC"
	
	if isFlagSet("GatekeeperWorkerKilled"):
		await destroyActiveObject(gatekeeper_npc)
