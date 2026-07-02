extends Node2D

var tab_header_buttons = []

signal tab_selected


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node is TabHeaderButton:
			tab_header_buttons.append(node)
			node.tab_selected.connect(tabSelected)


func tabSelected(button_in: TabHeaderButton) -> void:
	for button in tab_header_buttons:
		if button == button_in:
			button.select()
		else:
			button.deselect()
	emit_signal("tab_selected", button_in.getButtonText())


func hasButtonWithName(name_in: String) -> bool:
	for button in tab_header_buttons:
		if button.getButtonText().to_upper() == name_in.to_upper():
			return true
	return false


func selectFirst():
	if tab_header_buttons.is_empty():
		push_error("ERROR: Tried to select first from empty tab header list " + name)
	else:
		tabSelected(tab_header_buttons[0])
