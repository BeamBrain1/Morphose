extends DialogBox

var battle_messages: Array[String] = []
var persist: bool = false	# Remain visible after message display complete?
var awaiting_end_of_message_prompt: bool = false
var outputting_message: bool = false	# Is the box currently outputting a message?
const WRITE_CHAR_INTERVAL: float = 0.04
const POST_ENDLINE_DELAY: float = 0.2
var TEXT_BOX_HEIGHT: int = 0
var queue_show_full_message: bool = false

signal end_display


func _ready() -> void:
	TEXT_BOX_HEIGHT = int($Text.size.y)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		if outputting_message:
			queue_show_full_message = true
		elif awaiting_end_of_message_prompt:
			endMessageDisplay()


func pushBattleMessage(message: String) -> void:
	battle_messages.append(message)


# manual_close: Should message box remain until closed by user input?
# append: Should battle messages be appended to current text instead of overwriting it?
# persist_in: Should message box remain open after finishing display?
func displayMessages(manual_close: bool = false, append: bool = false, persist_in: bool = false) -> void:
	persist = persist_in
	if not append:
		$Text.text = ""
	$Text.visible_characters = $Text.text.length()
	while not battle_messages.is_empty():
		$Text.text += battle_messages.pop_front() + "\n"
	show()
	await get_tree().create_timer(0.1).timeout
	
	await showMessagesCharacterByCharacter()
	
	if manual_close:
		awaiting_end_of_message_prompt = true
	else:
		endMessageDisplay()


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
		trimTextToDisplayableRows()
	outputting_message = false


func showFullMessage() -> void:
	$Text.visible_characters = $Text.text.length()


func hasMessagesWaiting() -> bool:
	return not battle_messages.is_empty()


func isOpen() -> bool:
	return visible


func close() -> void:
	hide()


func endMessageDisplay() -> void:
	if isOpen():
		if not persist:
			close()
		emit_signal("end_display")


# How many text rows does the box have room to display simultaneously?
func numberOfDisplayableTextRows() -> int:
	return TEXT_BOX_HEIGHT / $Text.get_line_height()


# Trim the text to the number of displayable rows, cutting off the oldest first
# Ending newline characters create an empty row, so if there is one, subtract 1 from line count
func trimTextToDisplayableRows() -> void:
	# Ensure num. characters to display does not exceed string size
	$Text.visible_characters = mini($Text.visible_characters, $Text.text.length())
	if $Text.visible_characters > 0 and $Text.text[$Text.visible_characters-1] == "\n":
		$Text.lines_skipped = maxi(0, ($Text.get_line_count() - 1) - numberOfDisplayableTextRows())
	else:
		$Text.lines_skipped = maxi(0, ($Text.get_line_count()) - numberOfDisplayableTextRows())
