class_name OverworldPosition
extends Node

var map_name: String = ""
var grid_position: Vector2 = Vector2(0, 0)


func _init(map_in: String = "", grid_position_in: Vector2 = Vector2(0, 0)):
	map_name = map_in
	grid_position = grid_position_in
