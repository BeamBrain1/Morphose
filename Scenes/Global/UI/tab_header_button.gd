class_name TabHeaderButton
extends Button


@export var TabHeaderDefault: StyleBoxTexture
@export var TabHeaderSelected: StyleBoxFlat

const COLOR_TEXT_SELECTABLE: Color = Color(1, 1, 1, 1)
const COLOR_TEXT_UNSELECTABLE: Color = Color(0.666, 0.666, 0.666, 1)

signal tab_selected
var tab_name: String


func _ready() -> void:
	tab_name = text


func _on_pressed() -> void:
	emit_signal("tab_selected", self)


func select() -> void:
	disabled = true
	add_theme_stylebox_override("disabled", TabHeaderSelected)
	add_theme_color_override("font_disabled_color", COLOR_TEXT_SELECTABLE)


func deselect() -> void:
	disabled = false
	add_theme_stylebox_override("disabled", TabHeaderDefault)
	add_theme_color_override("font_disabled_color", COLOR_TEXT_UNSELECTABLE)


func getButtonText() -> String:
	return tab_name.lstrip(" ").rstrip(" ")
