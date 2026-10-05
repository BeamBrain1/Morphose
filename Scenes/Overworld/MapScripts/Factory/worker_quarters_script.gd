extends MapScript


func body() -> void:
	if isFlagSet("WorkerQuartersScriptRun"):
		pass
	else:
		await setFlag("WorkerQuartersScriptRun")
		await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "\"It's IN THE LIVING QUARTERS! What's Security doing?\"")
