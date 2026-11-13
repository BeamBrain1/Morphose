class_name SpokenDialogBox
extends DialogBox

const SYSTEM_DIALOG: String = "SYSTEM"

var awaiting_end_of_message_prompt: bool = false
var outputting_message: bool = false	# Is the box currently outputting a message?
const WRITE_CHAR_INTERVAL: float = 0.04
const POST_ENDLINE_DELAY: float = 0.2
var queue_show_full_message: bool = false

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
	if outputting_message:
		queue_show_full_message = true
	return false


func showFullMessage() -> void:
	$Text.visible_characters = $Text.text.length()


# Returns true if message is currently being fully displayed, false otherwise
func fullMessageVisible() -> bool:
	return $Text.visible_characters == -1 or $Text.visible_characters >= $Text.text.length()


# Output text one character at a time
func showMessagesCharacterByCharacter() -> void:
	queue_show_full_message = false
	outputting_message = true
	while $Text.visible_characters < $Text.text.length():
		if $Text.text[$Text.visible_characters] == "\n":	# If about to draw an endline cahracter, use endline delay
			await get_tree().create_timer(POST_ENDLINE_DELAY).timeout
		else:	# Otherwise, use normal character delay
			await get_tree().create_timer(WRITE_CHAR_INTERVAL).timeout
		$Text.visible_characters += 1
		if queue_show_full_message:
			$Text.visible_characters = $Text.text.length()
	outputting_message = false
