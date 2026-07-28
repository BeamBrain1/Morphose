extends Button

var blueprint

var predecessors_only = false

@export var PredecessorOnlyDefault: StyleBoxTexture
@export var PredecessorOnlyHighlight: StyleBoxFlat

signal choose_blueprint
signal open_predecessors_menu


func _ready() -> void:
	$PredecessorsDropdownButton.hide()
	$DropdownArrow.hide()


func assignBlueprint(blueprint_in, actor_tp: int, check_predecessors: bool = false) -> void:
	blueprint = blueprint_in
	text = blueprint.getMenuDisplayName() + "  " + str(blueprint.getTechPointCost()).lpad(3) + " TP "
	
	disabled = blueprint_in.getTechPointCost() > actor_tp
	
	if check_predecessors:
		if blueprint_in.hasPredecessors():
			if not disabled:
				setIncludePredecessors()
			if disabled and blueprint.sufficientTPForAtLeastOnePredecessor(actor_tp):
				setPredecessorsOnly()


func _on_pressed() -> void:
	if predecessors_only:
		openPredecessorsMenu()
	else:
		emit_signal("choose_blueprint", blueprint)


func setIncludePredecessors() -> void:
	$PredecessorsDropdownButton.show()
	$DropdownArrow.show()


func setPredecessorsOnly() -> void:
	predecessors_only = true
	disabled = false
	add_theme_stylebox_override("normal", PredecessorOnlyDefault)
	add_theme_stylebox_override("hover", PredecessorOnlyHighlight)
	size.x += 8
	$DropdownArrow.show()


func _on_predecessors_dropdown_button_pressed() -> void:
	openPredecessorsMenu()


func openPredecessorsMenu() -> void:
	emit_signal("open_predecessors_menu", blueprint, global_position - Vector2(8, 8))
