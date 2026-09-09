class_name SpokenDialogBox
extends DialogBox

const SYSTEM_DIALOG: String = "SYSTEM"

func isOpen() -> bool:
	return visible


func displayBlueprintCollectedDialog(blueprint) -> void:
	displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Collected blueprint: " + blueprint.getDialogDisplayName())


func displayDialog(speaker: String, dialog: String) -> void:
	show()
	if speaker.matchn(SYSTEM_DIALOG):
		$LabelDialog.text = dialog
	else:
		$LabelDialog.text = speaker + "\n\n" + dialog


func close() -> void:
	hide()
