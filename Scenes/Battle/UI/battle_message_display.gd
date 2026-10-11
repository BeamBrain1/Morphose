extends ColorRect

var battle_messages: Array[String] = []
var persist: bool = false	# Remain visible after message display complete?
var awaiting_end_of_message_prompt: bool = false


signal end_display


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		endMessageDisplay()


func pushBattleMessage(message: String) -> void:
	battle_messages.append(message)


# manual_clear_only: Should message box only close on user prompt?
# append: Should battle messages be appended to current text instead of overwriting it?
# persist_in: Should message box remain open after finishing display?
func displayMessages(manual_clear_only: bool = false, append: bool = false, persist_in: bool = false) -> void:
	persist = persist_in
	if not append:
		$Text.text = ""
	while not battle_messages.is_empty():
		$Text.text += battle_messages.pop_front() + "\n"
	show()
	await get_tree().create_timer(0.1).timeout
	if not manual_clear_only:
		$DisplayDurationTimer.start()
	awaiting_end_of_message_prompt = true


func hasMessagesWaiting() -> bool:
	return not battle_messages.is_empty()


func close() -> void:
	hide()


func endMessageDisplay() -> void:
	if awaiting_end_of_message_prompt:
		if not persist:
			close()
		emit_signal("end_display")
		$DisplayDurationTimer.stop()	# In case message display was ended by button press
