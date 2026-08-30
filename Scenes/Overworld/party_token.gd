class_name PartyToken
extends AnimatedSprite2D

signal move
signal interact


func _process(delta) -> void:
	if Input.is_action_just_pressed("up"):
		attemptMoveUp()
	elif Input.is_action_just_pressed("down"):
		attemptMoveDown()
	elif Input.is_action_just_pressed("left"):
		attemptMoveLeft()
	elif Input.is_action_just_pressed("right"):
		attemptMoveRight()


func attemptMoveUp() -> void:
	play("up")
	emit_signal("move", GlobalProgramData.DIRECTION.UP)


func attemptMoveDown() -> void:
	play("down")
	emit_signal("move", GlobalProgramData.DIRECTION.DOWN)


func attemptMoveLeft() -> void:
	play("left")
	emit_signal("move", GlobalProgramData.DIRECTION.LEFT)


func attemptMoveRight() -> void:
	play("right")
	emit_signal("move", GlobalProgramData.DIRECTION.RIGHT)


func attemptInteract() -> void:
	emit_signal("interact", currentFacingDirection())


func currentFacingDirection() -> GlobalProgramData.DIRECTION:
	if animation == "up":
		return GlobalProgramData.DIRECTION.UP
	if animation == "down":
		return GlobalProgramData.DIRECTION.DOWN
	if animation == "left":
		return GlobalProgramData.DIRECTION.LEFT
	if animation == "right":
		return GlobalProgramData.DIRECTION.RIGHT

	push_error("Unable to convert animation to direction: " + animation)
	return GlobalProgramData.DIRECTION.UP
