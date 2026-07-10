class_name PartyMember
extends Morphose

const PARTY_MEMBER_1_NAME: String = "Primus"
const PARTY_MEMBER_2_NAME: String = "Defector"
const PARTY_MEMBER_3_NAME: String = "Scholar"

var bio_energy: int = 0		# Unspent bio-energy

var discounted_stats: Array[GlobalProgramData.COMBAT_STAT] = [] # Discounted stats are cheaper to upgrade than base cost


# Cost in bio-energy to boost a stat were it a given value
func costToBoostStatForValue(stat: GlobalProgramData.COMBAT_STAT, value: int) -> int:
	
	var result: int = value
	
	var is_odd: bool = result % 2 == 1
	
	# Discounted stats can be boosted at half price
	if stat in discounted_stats:
		result = result >> 1
	
	# HP/TP cost 25% to boost
	if stat in [GlobalProgramData.COMBAT_STAT.HP, GlobalProgramData.COMBAT_STAT.TECH_POINTS]:
		result = result >> 2
	
	# Round up for scaling - small change that stops it from getting out of hand
	if is_odd:
		result += 1
	
	return max(1, result)	# All boosts cost at least 1 point


# Cost in bio-energy to boost a given stat by 1 point from its current value
func costToBoostStatByOne(stat: GlobalProgramData.COMBAT_STAT) -> int:
	return costToBoostStatForValue(stat, getStatFromEnumType(stat))


func costToBoostStatBy(stat: GlobalProgramData.COMBAT_STAT, amount: int) -> int:
	
	var result: int = 0
	
	for i in range(amount):
		result += costToBoostStatForValue(stat, getStatFromEnumType(stat) + i)
	
	return result


func getStatFromEnumType(stat: GlobalProgramData.COMBAT_STAT) -> int:
	if stat == GlobalProgramData.COMBAT_STAT.HP:
		return hp
	if stat == GlobalProgramData.COMBAT_STAT.ATTACK:
		return attack
	if stat == GlobalProgramData.COMBAT_STAT.DEFENSE:
		return defense
	if stat == GlobalProgramData.COMBAT_STAT.SENSES:
		return senses
	if stat == GlobalProgramData.COMBAT_STAT.SPEED:
		return speed
	if stat == GlobalProgramData.COMBAT_STAT.TECH_POINTS:
		return tech_points
	push_error("Unrecognized stat: " + str(stat))
	return 0


func setStatFromEnumType(stat: GlobalProgramData.COMBAT_STAT, value: int) -> void:
	if stat == GlobalProgramData.COMBAT_STAT.HP:
		hp = clampi(value, HP_MINIMUM, HP_CAP)
	elif stat == GlobalProgramData.COMBAT_STAT.ATTACK:
		attack = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == GlobalProgramData.COMBAT_STAT.DEFENSE:
		defense = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == GlobalProgramData.COMBAT_STAT.SENSES:
		senses = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == GlobalProgramData.COMBAT_STAT.SPEED:
		speed = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == GlobalProgramData.COMBAT_STAT.TECH_POINTS:
		tech_points = clampi(value, TP_MINIMUM, TP_CAP)
	else:
		push_error("Unrecognized status type: " + str(stat))


func getStatMinimumFromEnumType(stat: GlobalProgramData.COMBAT_STAT) -> int:
	if stat == GlobalProgramData.COMBAT_STAT.HP:
		return HP_MINIMUM
	elif stat == GlobalProgramData.COMBAT_STAT.TECH_POINTS:
		return TP_MINIMUM
	else:
		return STAT_MINIMUM


func getStatMaximumFromEnumType(stat: GlobalProgramData.COMBAT_STAT) -> int:
	if stat == GlobalProgramData.COMBAT_STAT.HP:
		return HP_CAP
	elif stat == GlobalProgramData.COMBAT_STAT.TECH_POINTS:
		return TP_CAP
	else:
		return STAT_CAP


func canIncreaseStat(stat: GlobalProgramData.COMBAT_STAT) -> bool:
	return bio_energy >= costToBoostStatByOne(stat) and getStatFromEnumType(stat) < getStatMaximumFromEnumType(stat)


func canDecreaseStat(stat: GlobalProgramData.COMBAT_STAT) -> bool:
	return getStatFromEnumType(stat) > getStatMinimumFromEnumType(stat)


func statPlusOne(stat: GlobalProgramData.COMBAT_STAT) -> void:
	bio_energy -= costToBoostStatByOne(stat)
	setStatFromEnumType(stat, getStatFromEnumType(stat) + 1)


func statMinusOne(stat: GlobalProgramData.COMBAT_STAT) -> void:
	setStatFromEnumType(stat, getStatFromEnumType(stat) - 1)
	bio_energy += costToBoostStatByOne(stat)


# Reset all stats to minimum values, uninstall all blueprints, and refund all bio-energy
func liquidateBioEnergy() -> void:
	
	# Set stats to minimum values
	for stat in [GlobalProgramData.COMBAT_STAT.HP, GlobalProgramData.COMBAT_STAT.ATTACK, GlobalProgramData.COMBAT_STAT.DEFENSE, GlobalProgramData.COMBAT_STAT.SENSES, GlobalProgramData.COMBAT_STAT.SPEED, GlobalProgramData.COMBAT_STAT.TECH_POINTS]:
		while getStatFromEnumType(stat) > getStatMinimumFromEnumType(stat):
			statMinusOne(stat)

	# Uninstall blueprints
	for blueprint_list in [blueprints_attack, blueprints_support, blueprints_passive]:
		while not blueprint_list.is_empty():
			bio_energy += blueprint_list.pop_front().bio_energy_cost


# Free: If true, blueprint is installed without paying Muta
func installBlueprint(blueprint, free: bool = false) -> void:
	
	uninstallPredecessorsAndSuccessors(blueprint)
	
	if blueprint is BlueprintAttack:
		blueprints_attack.append(blueprint)
	elif blueprint is BlueprintSupport:
		blueprints_support.append(blueprint)
	elif blueprint is BlueprintPassive:
		blueprints_passive.append(blueprint)
	
	if not free:
		bio_energy -= blueprint.bio_energy_cost


func uninstallBlueprint(blueprint) -> void:
	var blueprint_list: Array
	var found: bool = false
	
	if blueprint is BlueprintAttack:
		blueprint_list = blueprints_attack
	elif blueprint is BlueprintSupport:
		blueprint_list = blueprints_support
	elif blueprint is BlueprintPassive:
		blueprint_list = blueprints_passive
	
	for i in range(blueprint_list.size()):
		if blueprint_list[i].equals(blueprint):
			blueprint_list.remove_at(i)
			found = true
			break
	
	if found:
		bio_energy += blueprint.bio_energy_cost
	else:
		push_error("Blueprint not found: " + blueprint.getDialogDisplayName())


# Remove different-numbered versions of an installed blueprint (e.g. if install Claw 2, remove Claw 1 and Claw 3)
func uninstallPredecessorsAndSuccessors(blueprint_in) -> void:
	var blueprint_list: Array
	
	if blueprint_in is BlueprintAttack:
		blueprint_list = blueprints_attack
	elif blueprint_in is BlueprintSupport:
		blueprint_list = blueprints_support
	elif blueprint_in is BlueprintPassive:
		blueprint_list = blueprints_passive
	
	var new_blueprint_list = []
	
	for item in blueprint_list:
		if item.isPredecessorOrSuccessorOf(blueprint_in):
			uninstallBlueprint(item)
	
	blueprint_list = new_blueprint_list


func getAllBlueprints() -> Array:
	return blueprints_attack + blueprints_support + blueprints_passive


func blueprintIsCompatible(blueprint_in) -> bool:
	if name == PARTY_MEMBER_1_NAME:
		return blueprint_in.primus_compatible
	elif name == PARTY_MEMBER_2_NAME:
		return blueprint_in.defector_compatible
	elif name == PARTY_MEMBER_3_NAME:
		return blueprint_in.scholar_compatible
	
	push_error("Blueprint compatibility check failed for party member " + name)
	return false
