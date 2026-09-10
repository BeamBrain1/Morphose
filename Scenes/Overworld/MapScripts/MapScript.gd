class_name MapScript
extends Node

var controller: ControllerOverworld


func attachController(controller_in: ControllerOverworld) -> void:
	controller = controller_in


# Override in derived class
func execute() -> void:
	push_error("Script undefined: " + name)


func displayDialog(speaker: String, dialog: String) -> void:
	controller.overworldUI().displayDialog(speaker, dialog)
	await controller.overworldUI().closed_dialog
