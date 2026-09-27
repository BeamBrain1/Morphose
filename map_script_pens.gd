extends MapScript


func body() -> void:
	for i in range(6):
		var livestock_name: String = "NPCLivestock" + str(i)
		if isFlagSet(livestock_name + "Killed"):
			destroyActiveObject(livestock_name)
	if isFlagSet("FarmPanelLoosened"):
		destroyActiveObject("LoosePanel")
