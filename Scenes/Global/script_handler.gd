class_name ScriptHandler
extends Node


var root: Root
var current_script: MapScript
var persistent_script	# Temporary storage for scripts that persist between controllers
signal execution_finished


func assignRoot(root_in: Root) -> void:
	root = root_in


func assignAndExecuteScript(script: MapScript) -> void:
	current_script = script.duplicate()
	add_child(current_script)
	current_script.attachHandler(self)
	current_script.execute()


func controllerOverworld() -> ControllerOverworld:
	return root.getControllerOverworldOrNull()


func scriptExecutionFinished() -> void:
	if current_script != null:
		current_script.call_deferred("queue_free")
		current_script = null
		emit_signal("execution_finished")


func setBattleResult(won: bool) -> void:
	if persistent_script != null:
		persistent_script.setBattleResult(won)


func hasCurrentScript() -> bool:
	return current_script != null


func hasPersistentScript() -> bool:
	return persistent_script != null


func storeCurrentScriptAsPersistent() -> void:
	persistent_script = current_script
	current_script = null


func resumeStoredPersistentScript() -> void:
	current_script = persistent_script
	persistent_script = null
	current_script.resumeExecution()


func onMapLoad(on_load_script: MapScript = null) -> void:
	if on_load_script != null:
		assignAndExecuteScript(on_load_script)
		await execution_finished
	if hasPersistentScript():
		resumeStoredPersistentScript()
