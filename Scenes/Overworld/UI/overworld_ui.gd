class_name OverworldUI
extends Node2D

signal closed_dialog



func _ready() -> void:
	closeDialog()


func inDialog() -> bool:
	return $SpokenDialogBox.isOpen()


func displayBlueprintCollectedDialog(blueprint) -> void:
	$SpokenDialogBox.displayBlueprintCollectedDialog(blueprint)


func displayDialog(speaker: String, dialog: String) -> void:
	$SpokenDialogBox.displayDialog(speaker, dialog)


# Advance dialog in dialog box. If this function is called when dialog fully displayed, close dialog box
func advanceDialog() -> void:
	if $SpokenDialogBox.advanceDialog():
		closeDialog()


func closeDialog() -> void:
	$SpokenDialogBox.close()
	emit_signal("closed_dialog")
