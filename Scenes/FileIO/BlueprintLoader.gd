class_name BlueprintLoader

const ENTRY_SEPARATOR: String = "-"
const KEY_VALUE_SEPARATOR: String = ":"
const DATA_PATH: String = "blueprints.dat"
const BP_TYPE_KEY: String = "TYPE"
const BP_TYPE_ATTACK: String = "ATTACK"
const BP_TYPE_SUPPORT: String = "SUPPORT"
const BP_TYPE_PASSIVE: String = "PASSIVE"
var file_terminator_reached: bool = false


static func blueprintList() -> Array:
	
	var result = []
	
	if FileAccess.file_exists(DATA_PATH):
		var blueprint_file: FileAccess = FileAccess.open(DATA_PATH, FileAccess.READ)
		while blueprint_file.get_position() < blueprint_file.get_length():
			result.append(readBlueprintEntry(blueprint_file))
		blueprint_file.close()
	else:
		push_error("Unable to find " + DATA_PATH)
	
	buildPredecessorBlueprints(result)
	
	return result


static func readBlueprintEntry(blueprint_file: FileAccess):
	
	var line: String = blueprint_file.get_line()
	# Always define type first in a blueprint's entry so we can initialize it - order of other elements doesn't matter
	var result = newBlueprintForType(line.split(KEY_VALUE_SEPARATOR)[1])
	line = blueprint_file.get_line()	# Read next line after blueprint type
	
	# Read until we hit entry terminator or EOF.
	while blueprint_file.get_position() < blueprint_file.get_length() and line != ENTRY_SEPARATOR:
		var key: String = line.split(KEY_VALUE_SEPARATOR)[0]
		var value: String = line.split(KEY_VALUE_SEPARATOR)[1]
		assignBlueprintAttribute(result, key, value)
		line = blueprint_file.get_line()
	
	return result


static func buildPredecessorBlueprints(blueprint_list: Array) -> void:
	for blueprint in blueprint_list:
		blueprint.buildPredecessorList(blueprint_list)


# Returns a new blueprint, class dependent on supplied type
# These blueprints will retain all default values unless overridden in their blueprints.dat entry
static func newBlueprintForType(type: String):
	
	if type == BP_TYPE_ATTACK:
		return BlueprintAttack.new()
	elif type == BP_TYPE_SUPPORT:
		return BlueprintSupport.new()
	elif type == BP_TYPE_PASSIVE:
		return BlueprintPassive.new()
	else:
		push_error("Unrecognized blueprint type: " + type)


static func assignBlueprintAttribute(blueprint, key: String, value: String) -> void:
	
	var key_upper: String = key.to_upper()		# Keys are case insensitive
	
	if key_upper == "NAME":
		blueprint.base_display_name = value
		return
	elif key_upper == "TIER":
		blueprint.tier = int(value)
		return
	elif key_upper == "OVERRIDE_NAME":
		blueprint.override_display_name = value
		return
	elif key_upper == "BIO_COST_TRACK":
		blueprint.bio_cost_track = value.to_upper()
		return
	elif key_upper == "TP_COST_TRACK":
		blueprint.tp_cost_track = value.to_upper()
		return
	elif key_upper == "MULTITARGET":
		blueprint.multitarget = valueIsTrue(blueprint, key, value)
		return
	elif key_upper == "PRIMUS":
		blueprint.primus_compatible = valueIsTrue(blueprint, key, value)
		return
	elif key_upper == "DEFECTOR":
		blueprint.defector_compatible = valueIsTrue(blueprint, key, value)
		return
	elif key_upper == "SCHOLAR":
		blueprint.scholar_compatible = valueIsTrue(blueprint, key, value)
		return
	elif key_upper == "SPECIAL":
		blueprint.special = value
		return
	
	
	if blueprint is BlueprintAttack:
		if key_upper == "DAMAGE":
			blueprint.base_damage = int(value)
			return
		elif key_upper == "DAMAGELESS":
			blueprint.damageless = valueIsTrue(blueprint, key, value)
			return
		elif key_upper == "HITS":
			blueprint.num_hits = int(value)
			return
		elif key_upper == "ACCURACY":
			blueprint.accuracy = int(value)
			return
		elif key_upper == "CRIT_RATE":
			blueprint.crit_rate = int(value)
			return
		elif key_upper == "FIXED_DAMAGE":
			blueprint.fixed_damage = valueIsTrue(blueprint, key, value)
			return
		elif key_upper == "ALWAYS_HIT":
			blueprint.always_hit = valueIsTrue(blueprint, key, value)
			return
		elif key_upper == "CRIT_RATE":
			blueprint.crit_rate = int(value)
			return
		elif key_upper == "BURNING":
			blueprint.burning = int(value)
			return
		elif key_upper == "TRANQED":
			blueprint.tranqed = int(value)
			return
		elif key_upper == "ACID":
			blueprint.acid = int(value)
			return
		elif key_upper == "BLIND":
			blueprint.blind = int(value)
			return
		elif key_upper == "SLIMED":
			blueprint.slimed = int(value)
			return
		elif key_upper == "RAGE":
			blueprint.rage = int(value)
			return
	elif blueprint is BlueprintSupport:
		if key_upper == "HEAL_AMOUNT":
			blueprint.base_healing = int(value)
			return
		elif key_upper == "REVIVES":
			blueprint.can_revive = valueIsTrue(blueprint, key, value)
			return
		elif key_upper == "SELF_ONLY":
			blueprint.self_only = valueIsTrue(blueprint, key, value)
			return
		elif key_upper == "REGEN":
			blueprint.regen = int(value)
			return
		elif key_upper == "SHARPENED":
			blueprint.sharpened = int(value)
			return
		elif key_upper == "HARDENED":
			blueprint.hardened = int(value)
			return
		elif key_upper == "KEEN":
			blueprint.keen = int(value)
			return
		elif key_upper == "ENERGIZED":
			blueprint.energized = int(value)
			return
		elif key_upper == "FOCUSED":
			blueprint.focused = int(value)
			return
		elif key_upper == "HEAL_BURNING":
			blueprint.heal_burning = int(value)
			return
		elif key_upper == "HEAL_TRANQED":
			blueprint.heal_tranqed = int(value)
			return
		elif key_upper == "HEAL_ACID":
			blueprint.heal_acid = int(value)
			return
		elif key_upper == "HEAL_BLIND":
			blueprint.heal_blind = int(value)
			return
		elif key_upper == "HEAL_SLIMED":
			blueprint.heal_slimed = int(value)
			return
		elif key_upper == "HEAL_RAGE":
			blueprint.heal_rage = int(value)
			return
		elif key_upper == "BURNING":
			blueprint.burning = int(value)
			return
		elif key_upper == "TRANQED":
			blueprint.tranqed = int(value)
			return
		elif key_upper == "ACID":
			blueprint.acid = int(value)
			return
		elif key_upper == "BLIND":
			blueprint.blind = int(value)
			return
		elif key_upper == "SLIMED":
			blueprint.slimed = int(value)
			return
		elif key_upper == "RAGE":
			blueprint.rage = int(value)
			return
	elif blueprint is BlueprintPassive:
		if key_upper == "VALUE":
			blueprint.value = int(value)
			return
	else:
		push_error("Blueprint load error: " + blueprint.getDialogDisplayName() + " has unrecognized type")
	push_error("Blueprint load error: " + blueprint.getDialogDisplayName() + " contains unrecognized key " + key)


static func valueIsTrue(blueprint, key: String, value: String) -> bool:
	if value == "T":
		return true
	elif value == "F":
		return false
	else:
		push_error("Unrecognized truth value for " + blueprint.getDialogDisplayName() + ", " + key + ". Should be \"T\" or \"F\" but was " + value + ".")
		return false
