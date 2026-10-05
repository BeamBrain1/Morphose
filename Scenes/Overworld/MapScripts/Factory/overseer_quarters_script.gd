extends MapScript


func body() -> void:
	if not isFlagSet("OverseerQuartersScriptRun"):
		setFlag("OverseerQuartersScriptRun")
		await displayDialog("Defector", "So these are the Overseer's quarters, huh? Figures they're keeping an entire room to themself.")
		await displayDialog("Defector", "And they have a private modification station, too? Well, if they aren't around, may as well use it ourselves!")
		await displayDialog("Defector", "We can boost stats and install blueprints any time, but we can only decrease and uninstall at a station.")
