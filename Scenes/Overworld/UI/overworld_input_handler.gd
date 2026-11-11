class_name OverworldInputHandler
extends Node

var UI: OverworldUI
var party_token: PartyToken

var player_controls_locked: bool = false

signal request_open_char_builder


func _process(delta):
	processInput()


func processInput() -> void:
	if UI.inDialog():
		if Input.is_action_just_pressed("overworld_interact"):
			UI.advanceDialog()
	elif not player_controls_locked:
		if Input.is_action_just_pressed("pause"):
			emit_signal("request_open_char_builder")
		elif Input.is_action_pressed("up"):
			party_token.attemptMoveTo(GlobalProgramData.DIRECTION.UP)
		elif Input.is_action_pressed("down"):
			party_token.attemptMoveTo(GlobalProgramData.DIRECTION.DOWN)
		elif Input.is_action_pressed("left"):
			party_token.attemptMoveTo(GlobalProgramData.DIRECTION.LEFT)
		elif Input.is_action_pressed("right"):
			party_token.attemptMoveTo(GlobalProgramData.DIRECTION.RIGHT)
		elif Input.is_action_just_pressed("overworld_interact"):
			party_token.attemptInteract()


func lockPlayerControls() -> void:
	player_controls_locked = true


func unlockPlayerControls() -> void:
	player_controls_locked = false
