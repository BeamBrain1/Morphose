class_name ScriptHandler
extends Node


var root: Root
var current_script: MapScript



func assignRoot(root_in: Root) -> void:
	root = root_in


func assignAndExecuteScript(script: MapScript) -> void:
	current_script = script
	script.reparent(self)
	script.attachHandler(self)
	script.execute()


func controllerOverworld() -> ControllerOverworld:
	return root.getControllerOverworldOrNull()


func clearScript() -> void:
	current_script.call_deferred("queue_free")
	current_script = null


func resumeScriptExecution() -> void:
	if hasScript():
		current_script.resumeExecution()


func hasScript() -> bool:
	return current_script != null
