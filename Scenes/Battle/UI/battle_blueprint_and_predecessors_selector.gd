extends DialogBox

var base_blueprint

const FIRST_BLUEPRINT_POSITION: Vector2 = Vector2(8, 8)
const BLUEPRINT_X_OFFSET: int = 104
const BLUEPRINT_Y_OFFSET: int = ROW_HEIGHT_PX

signal choose_blueprint
signal cancel

@export var BlueprintActionButton: PackedScene

func assignBlueprint(blueprint, available_tp: int) -> void:
	
	var blueprint_and_predecessors = [blueprint]
	
	for predecessor in blueprint.predecessors:
		blueprint_and_predecessors.append(predecessor)
	
	blueprint_and_predecessors.sort_custom(Blueprint.sortBlueprintsDescending)
	
	for i in range(blueprint_and_predecessors.size()):
		var blueprint_button = BlueprintActionButton.instantiate()
		add_child(blueprint_button)
		blueprint_button.choose_blueprint.connect(chooseBlueprint)
		blueprint_button.assignBlueprint(blueprint_and_predecessors[i], available_tp, false)
		blueprint_button.position = FIRST_BLUEPRINT_POSITION + Vector2(0, BLUEPRINT_Y_OFFSET * i)

	num_rows = ceili(blueprint_and_predecessors.size()) + 2		# Add 2 for cancel button
	setSizeAndPosition()
	
	# If window goes below bottom of screen, expand it upward instead
	if extendsPastScreenBottom():
		expands_down = false
		size.y = ROW_HEIGHT_PX
		setSizeAndPosition()
	
	$ButtonCancel.position.y = size.y - (ROW_HEIGHT_PX * 2)


func chooseBlueprint(blueprint) -> void:
	emit_signal("choose_blueprint", blueprint)


func cancelPressed() -> void:
	emit_signal("cancel")
