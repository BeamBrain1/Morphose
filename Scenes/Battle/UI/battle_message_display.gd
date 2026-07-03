extends ColorRect

var battle_messages: Array[String] = []

signal display_timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		if displayingTemporaryMessage():
			endMessageDisplay()


func pushBattleMessage(message: String) -> void:
	battle_messages.append(message)


func displayMessages(remain_until_cleared: bool = false) -> void:
	$Text.text = ""
	while not battle_messages.is_empty():
		$Text.text += battle_messages.pop_front() + "\n"
	show()
	await get_tree().create_timer(0.1).timeout
	if not remain_until_cleared:
		$DisplayDurationTimer.start()


func hasMessagesWaiting() -> bool:
	return not battle_messages.is_empty()


func close() -> void:
	hide()


func endMessageDisplay() -> void:
	close()
	emit_signal("display_timeout")
	$DisplayDurationTimer.stop()	# In case message display was ended by button press


func displayingTemporaryMessage() -> bool:
	return not $DisplayDurationTimer.is_stopped()
