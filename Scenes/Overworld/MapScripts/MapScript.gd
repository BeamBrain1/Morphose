class_name MapScript
extends Node

@export var actions: Array[String]
enum COMPARATOR_TYPE {CLEARED, SET, EQ, NE, GT, GTE, LT, LTE}
enum CHECK_VALUE_TYPE {FLAG_NAME, CONSTANT}


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
