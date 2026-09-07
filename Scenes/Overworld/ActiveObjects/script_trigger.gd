extends Sprite2D

enum ACTIVATION_TYPE {STEP, INTERACT}
@export var activation_type: ACTIVATION_TYPE
@export var destroy_on_script_execution: bool = false
@export var map_script: PackedScene

@export var has_destroy_on_load_condition: bool = false

@export var dol_flag: String
@export var dol_comparator_type: MapScript.COMPARATOR_TYPE
@export var dol_check_value_type: MapScript.CHECK_VALUE_TYPE
@export var dol_check_value: String


func _ready() -> void:
	if has_destroy_on_load_condition:
		if MapScript.scriptConditionMet(dol_flag, dol_comparator_type, dol_check_value_type, dol_check_value):
			call_deferred("queue_free")
