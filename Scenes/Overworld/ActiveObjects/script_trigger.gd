class_name ScriptTrigger
extends ActiveMapObject

enum COMPARATOR_TYPE {CLEARED, SET, EQ, NE, GT, GTE, LT, LTE}
enum CHECK_VALUE_TYPE {FLAG_NAME, CONSTANT}

enum ACTIVATION_TYPE {STEP, INTERACT}

@export var activation_type: ACTIVATION_TYPE
@export var destroy_on_script_execution: bool = false
@export var map_script: MapScript

@export var has_destroy_on_load_condition: bool = false

@export var dol_flag: String
@export var dol_comparator_type: COMPARATOR_TYPE
@export var dol_check_value_type: CHECK_VALUE_TYPE
@export var dol_check_value: String

signal request_script_execution

func _ready() -> void:
	if has_destroy_on_load_condition:
		if scriptConditionMet(dol_flag, dol_comparator_type, dol_check_value_type, dol_check_value):
			call_deferred("queue_free")
	if get_children().size() == 0:
		push_error("Script trigger " + name + " has no attached script")
	elif get_children().size() > 1:
		push_error("Script trigger " + name + " has multiple attached scripts")
	elif not get_children()[0] is MapScript:
		push_error("Script trigger " + name + " has non-Map Script child: " + get_children()[0].name)
	else:
		map_script = get_children()[0]


func requestScriptExecution() -> void:
	emit_signal("request_script_execution", self)


func executeAttachedScript(controller: ControllerOverworld) -> void:
	map_script.attachController(controller)
	await map_script.execute()	# Don't destroy until script execution complete
	if destroy_on_script_execution:
		call_deferred("queue_free")


static func scriptConditionMet(flag: String, comparator_type: COMPARATOR_TYPE, check_value_type: CHECK_VALUE_TYPE = CHECK_VALUE_TYPE.CONSTANT, check_value: String = "0") -> bool:
	match comparator_type:
		COMPARATOR_TYPE.CLEARED:
			return not ActiveSaveData.overworld_flags.isflagSet(flag)
		COMPARATOR_TYPE.SET:
			return ActiveSaveData.overworld_flags.isflagSet(flag)
		COMPARATOR_TYPE.EQ:
			return ActiveSaveData.overworld_flags.getFlagIntValue(flag) == getConditionalCheckValue(check_value_type, check_value)
		COMPARATOR_TYPE.EQ:
			return ActiveSaveData.overworld_flags.getFlagIntValue(flag) == getConditionalCheckValue(check_value_type, check_value)
		COMPARATOR_TYPE.NE:
			return ActiveSaveData.overworld_flags.getFlagIntValue(flag) != getConditionalCheckValue(check_value_type, check_value)
		COMPARATOR_TYPE.GT:
			return ActiveSaveData.overworld_flags.getFlagIntValue(flag) > getConditionalCheckValue(check_value_type, check_value)
		COMPARATOR_TYPE.GTE:
			return ActiveSaveData.overworld_flags.getFlagIntValue(flag) >= getConditionalCheckValue(check_value_type, check_value)
		COMPARATOR_TYPE.LT:
			return ActiveSaveData.overworld_flags.getFlagIntValue(flag) < getConditionalCheckValue(check_value_type, check_value)
		COMPARATOR_TYPE.LTE:
			return ActiveSaveData.overworld_flags.getFlagIntValue(flag) <= getConditionalCheckValue(check_value_type, check_value)
		_:
			push_error("Unprocessed conditional type: " + str(comparator_type))
	return false


static func getConditionalCheckValue(type: CHECK_VALUE_TYPE, value: String) -> int:
	if type == CHECK_VALUE_TYPE.CONSTANT:
		return int(value)
	else:
		return ActiveSaveData.overworld_flags.getFlagIntValue(value)


func steppedOn() -> void:
	if activation_type == ACTIVATION_TYPE.STEP:
		requestScriptExecution()


func interactedWith() -> void:
	if activation_type == ACTIVATION_TYPE.INTERACT:
		requestScriptExecution()
