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
		$Text.text = dialog
	else:
		$Text.text = speaker + "\n\n" + dialog


func close() -> void:
	hide()


# Advance dialog. Returns true if dialog was fully displayed when this function was called
func advanceDialog() -> bool:
	if fullMessageVisible():
		return true
	showFullMessage()
	return false


func showFullMessage() -> void:
	$Text.visible_characters = $Text.text.length()


# Returns true if message is currently being fully displayed, false otherwise
func fullMessageVisible() -> bool:
	return $Text.visible_characters == -1 or $Text.visible_characters >= $Text.text.length()
