extends DialogBox

const BLUEPRINTS_PER_LINE: int = 3
const FIRST_BLUEPRINT_POSITION: Vector2 = Vector2(16, 8)
const BLUEPRINT_X_OFFSET: int = 104
const BLUEPRINT_Y_OFFSET: int = ROW_HEIGHT_PX

signal choose_blueprint
signal cancel

var active_predecessor_submenu = null

var available_tp: int

@export var BlueprintActionButton: PackedScene
@export var BlueprintAndPredecessorsMenu: PackedScene

func assignBlueprintList(blueprints: Array, available_tp_in: int) -> void:
	available_tp = available_tp_in
	num_rows = ceili(blueprints.size()/BLUEPRINTS_PER_LINE) + 3		# Add 3 for cancel button
	setSizeAndPosition()
	$ButtonCancel.position.y = size.y - (ROW_HEIGHT_PX * 2)
	blueprints.sort_custom(Blueprint.sortBlueprintsAscendingBattle)
	for i in range(blueprints.size()):
		var blueprint_button = BlueprintActionButton.instantiate()
		add_child(blueprint_button)
		blueprint_button.choose_blueprint.connect(chooseBlueprint)
		blueprint_button.open_predecessors_menu.connect(openBlueprintAndPredecessorsMenu)
		blueprint_button.assignBlueprint(blueprints[i], available_tp, true)
		blueprint_button.position = FIRST_BLUEPRINT_POSITION + Vector2(BLUEPRINT_X_OFFSET * (i % BLUEPRINTS_PER_LINE), BLUEPRINT_Y_OFFSET * floor(i / BLUEPRINTS_PER_LINE))


func chooseBlueprint(blueprint) -> void:
	emit_signal("choose_blueprint", blueprint)


func openBlueprintAndPredecessorsMenu(blueprint, submenu_global_position) -> void:
	
	if active_predecessor_submenu != null:
		closeActiveBlueprintAndPredecessorsMenu()
	
	var predecessor_submenu = BlueprintAndPredecessorsMenu.instantiate()
	add_child(predecessor_submenu)
	predecessor_submenu.choose_blueprint.connect(chooseBlueprint)
	predecessor_submenu.cancel.connect(closeActiveBlueprintAndPredecessorsMenu)
	predecessor_submenu.assignBlueprint(blueprint, available_tp)
	predecessor_submenu.global_position = submenu_global_position
	active_predecessor_submenu = predecessor_submenu


func cancelPressed() -> void:
	emit_signal("cancel")


func closeActiveBlueprintAndPredecessorsMenu():
	if active_predecessor_submenu != null:
		active_predecessor_submenu.call_deferred("queue_free")
		active_predecessor_submenu = null
