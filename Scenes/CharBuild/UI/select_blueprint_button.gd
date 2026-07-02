class_name SelectBlueprintButton
extends Button

var blueprint

signal choose_blueprint


func assignBlueprint(blueprint_in, actor_tp: int, check_predecessors: bool = false) -> void:
	blueprint = blueprint_in
	text = blueprint.getMenuDisplayName() + "  " + str(blueprint.tp_cost).lpad(3) + " TP "
	disabled = blueprint_in.tp_cost > actor_tp


func _on_pressed() -> void:
	emit_signal("choose_blueprint", blueprint)
