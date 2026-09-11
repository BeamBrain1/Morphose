class_name OverworldFlags
extends Object

const DEFAULT_FLAG_VALUE: int = 0
const FLAG_SET_VALUE: int = 1
const FLAG_CLEARED_VALUE: int = 0

var flags: Dictionary = {}	# Keys are strings, values are ints


# Returns flag value for key, or default value if flag not present
func getFlagIntValue(flag: String) -> int:
	if not flags.has(flag.to_upper()):
		flags[flag] = DEFAULT_FLAG_VALUE
	return flags[flag.to_upper()]


func setFlagIntValue(flag: String, value: int) -> void:
	flags[flag.to_upper()] = value


# A nonzero value is treated as set; 0 is not set
func isFlagSet(flag: String) -> bool:
	return getFlagIntValue(flag.to_upper()) != DEFAULT_FLAG_VALUE


func setFlag(flag: String) -> void:
	flags[flag.to_upper()] = FLAG_SET_VALUE


func clearFlag(flag: String) -> void:
	flags[flag.to_upper()] = FLAG_CLEARED_VALUE


# Add int to flag. If flag not present, push an error
func addTo(flag: String, value: int) -> void:
	if flags.has(flag.to_upper()):
		flags[flag.to_upper()] += value
	else:
		push_error("Flag not present: " + flag)


# Sub int from flag. If flag not present, push an error
func subFrom(flag: String, value: int) -> void:
	if flags.has(flag.to_upper()):
		flags[flag.to_upper()] -= value
	else:
		push_error("Flag not present: " + flag)
