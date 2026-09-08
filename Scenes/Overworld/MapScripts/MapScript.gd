class_name MapScript
extends Node

@export var actions: Array[String]
enum COMPARATOR_TYPE {CLEARED, SET, EQ, NE, GT, GTE, LT, LTE}
enum CHECK_VALUE_TYPE {FLAG_NAME, CONSTANT}

const VARIABLE_PREFIX: String = "@"
const FUNC_DELIMITER: String = ":"
const PARAM_DELIMITER: String = ","

const CMD_DIALOG: String = "DIALOG"
const CMD_PUSH: String = "PUSH"
const CMD_SET_FLAG: String = "SET_FLAG"
const CMD_CLEAR_FLAG: String = "CLEAR_FLAG"
const CMD_SET_FLAG_INT: String = "SET_FLAG_INT"
const CMD_ADD_TO_FLAG: String = "ADD"
const CMD_SUB_FROM_FLAG: String = "SUB"
const CMD_JUMP: String = "JUMP"
const CMD_JUMP_IF: String = "JUMP_IF"
const CMD_END: String = "END"
const CMD_ENDIF: String = "END_IF"
const CMD_SET_TILE: String = "SET_TILE"
const CMD_CREATE_ACTIVE_OBJECT: String = "CREATE_ACTIVE_OBJECT"
const CMD_DESTROY_ACTIVE_OBJECT: String = "CREATE_ACTIVE_OBJECT"
const CMD_LOOP: String = "LOOP"


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
