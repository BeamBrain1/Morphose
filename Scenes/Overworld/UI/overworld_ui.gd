class_name OverworldUI
extends Node2D


func _ready() -> void:
	closeDialog()


func inDialog() -> bool:
	return $SpokenDialogBox.isOpen()


func displayBlueprintCollectedDialog(blueprint) -> void:
	$SpokenDialogBox.displayBlueprintCollectedDialog(blueprint)


func displayDialog(speaker: String, dialog: String) -> void:
	$SpokenDialogBox.displayDialog(speaker, dialog)


func closeDialog() -> void:
	$SpokenDialogBox.close()
