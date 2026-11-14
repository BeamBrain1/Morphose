class_name SpokenDialogBox
extends DialogBox

const SYSTEM_DIALOG: String = "SYSTEM"

var awaiting_end_of_message_prompt: bool = false
var outputting_message: bool = false	# Is the box currently outputting a message?
const WRITE_CHAR_INTERVAL: float = 0.04
const START_WRITE_DELAY: float = 0.1

var queue_show_full_message: bool = false

func isOpen() -> bool:
	return visible


func displayBlueprintCollectedDialog(blueprint) -> void:
	displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Collected blueprint: " + blueprint.getDialogDisplayName())


func displayDialog(speaker: String, dialog: String) -> void:
	show()
	if speaker.matchn(SYSTEM_DIALOG):
		$Text.text = dialog
		$Text.visible_characters = 0
	else:
		$Text.text = speaker + "\n\n" + dialog
		$Text.visible_characters = speaker.length() + 1	# Speaker is displayed all at once
	showDialogCharacterByCharacter()


func close() -> void:
	hide()


# Advance dialog. Returns true if dialog was fully displayed when this function was called
func advanceDialog() -> bool:
	if fullDialogVisible():
		return true
	if outputting_message:
		queue_show_full_message = true
	return false


func showFullDialog() -> void:
	$Text.visible_characters = $Text.text.length()


# Returns true if message is currently being fully displayed, false otherwise
func fullDialogVisible() -> bool:
	return $Text.visible_characters == -1 or $Text.visible_characters >= $Text.text.length()


# Output text one character at a time
func showDialogCharacterByCharacter() -> void:
	queue_show_full_message = false
	outputting_message = true
	await get_tree().create_timer(START_WRITE_DELAY).timeout
	while $Text.visible_characters < $Text.text.length():
		await get_tree().create_timer(WRITE_CHAR_INTERVAL).timeout
		$Text.visible_characters += 1
		$AudioWriteChar.play()
		if queue_show_full_message:
			$Text.visible_characters = $Text.text.length()
	outputting_message = false
