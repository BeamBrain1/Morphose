class_name Controller
extends Node2D

var root	# The root node

signal switch_to_battle_controller
signal switch_to_overworld_controller
signal switch_to_char_build_controller

func switchToBattleController(enemy_list: Array) -> void:
	emit_signal("switch_to_battle_controller", enemy_list)


func switchToOverworldController() -> void:
	emit_signal("switch_to_overworld_controller")


func switchToCharBuildController(at_modification_station: bool = true) -> void:
	emit_signal("switch_to_char_build_controller", at_modification_station)
