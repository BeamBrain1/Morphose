class_name PartyMember
extends Morphose

const HP_CAP: int = 999
const HP_DIMINISHING_RETURNS_START: int = 500
const HP_DIMINISHING_RETURNS_INTERVAL: int = 20
const TP_CAP: int = 999
const TP_DIMINISHING_RETURNS_START: int = 500
const TP_DIMINISHING_RETURNS_INTERVAL: int = 20
const STAT_DIMINISHING_RETURNS_START: int = 125
const STAT_FAVORED_DIMINISHING_RETURNS_START: int = 150
const STAT_DIMINISHING_RETURNS_INTERVAL: int = 5
const STAT_CAP: int = 250

const PARTY_MEMBER_PRIMUS_NAME: String = "Primus"
const PARTY_MEMBER_DEFECTOR_NAME: String = "Defector"
const PARTY_MEMBER_SCHOLAR_NAME: String = "Scholar"

var bio_energy: int = 0		# Unspent bio-energy
const MAX_STORED_BIO_ENERGY: int = 99999
const STARTING_BIO_ENERGY: int = 0

var discounted_stats: Array[COMBAT_STAT] = [] # Discounted stats are cheaper to upgrade than base cost

const STARTING_BLUEPRINT_SLOTS: int = 4
var blueprint_slots: int = STARTING_BLUEPRINT_SLOTS
const MAX_BLUEPRINT_SLOTS: int = 12
const BASE_ADD_BLUEPRINT_SLOT_MUTA_COST: int = 100
const ADD_BLUEPRINT_COST_MULTIPLIER: int = 2


# Does a deep copy of target party member
static func deepCopy(original: PartyMember) -> PartyMember:
	var copy: PartyMember = PartyMember.new()
	copy.name = original.name
	copy.hp = original.hp
	copy.attack = original.attack
	copy.defense = original.defense
	copy.senses = original.senses
	copy.speed = original.speed
	copy.tech_points = original.tech_points
	copy.blueprints_attack = original.blueprints_attack.duplicate_deep()
	copy.blueprints_support = original.blueprints_support.duplicate_deep()
	copy.blueprints_passive = original.blueprints_passive.duplicate_deep()
	copy.bio_energy = original.bio_energy
	copy.discounted_stats = original.discounted_stats.duplicate_deep()
	copy.blueprint_slots = original.blueprint_slots
	return copy


# Cost in bio-energy to boost a stat were it a given value
func costToBoostStatForValue(stat: COMBAT_STAT, value: int) -> int:
	
	var result: int = value
	
	var is_odd: bool = result % 2 == 1
	
	var diminishing_returns_start: int
	
	if stat == Morphose.COMBAT_STAT.HP:
		diminishing_returns_start = HP_DIMINISHING_RETURNS_START
	elif stat == Morphose.COMBAT_STAT.TECH_POINTS:
		diminishing_returns_start = TP_DIMINISHING_RETURNS_START
	else:
		diminishing_returns_start = STAT_DIMINISHING_RETURNS_START
	
	if stat in discounted_stats:
		if stat in [Morphose.COMBAT_STAT.HP, Morphose.COMBAT_STAT.TECH_POINTS]:
			diminishing_returns_start *= 5
			diminishing_returns_start /= 4
		else:
			diminishing_returns_start = STAT_FAVORED_DIMINISHING_RETURNS_START
	
	if stat == Morphose.COMBAT_STAT.HP:
		result -= HP_MINIMUM
		if result + HP_MINIMUM >= diminishing_returns_start:		# After hitting diminishing returns point, cost doubles regularly
			result += result * (1 + ((result - diminishing_returns_start) / HP_DIMINISHING_RETURNS_INTERVAL))
	elif stat == Morphose.COMBAT_STAT.TECH_POINTS:
		result -= TP_MINIMUM
		if result + TP_MINIMUM >= diminishing_returns_start:
			result += result * (1 + ((result - diminishing_returns_start) / TP_DIMINISHING_RETURNS_INTERVAL))
	else:
		result -= STAT_MINIMUM
		if result + STAT_MINIMUM >= diminishing_returns_start:
			result += result * (1 + ((result - diminishing_returns_start) / STAT_DIMINISHING_RETURNS_INTERVAL))
	
	
	result = maxi(1, result)
	
	# Discounted stats can be boosted at 3/4 price
	if stat in discounted_stats:
		result = maxi(1, (result * 3) / 4)
	
	# HP/TP cost 25% to boost
	if stat in [Morphose.COMBAT_STAT.HP, Morphose.COMBAT_STAT.TECH_POINTS]:
		result = roundi(float(result) / 4)
	
	return maxi(1, result)	# All boosts cost at least 1 point


func getRawStatFromEnumType(stat: COMBAT_STAT) -> int:
	if stat == Morphose.COMBAT_STAT.HP:
		return mini(hp, HP_CAP)
	if stat == Morphose.COMBAT_STAT.ATTACK:
		return mini(attack, STAT_CAP)
	if stat == Morphose.COMBAT_STAT.DEFENSE:
		return mini(defense, STAT_CAP)
	if stat == Morphose.COMBAT_STAT.SENSES:
		return mini(senses, STAT_CAP)
	if stat == Morphose.COMBAT_STAT.SPEED:
		return mini(speed, STAT_CAP)
	if stat == Morphose.COMBAT_STAT.TECH_POINTS:
		return mini(tech_points, TP_CAP)
	push_error("Unrecognized stat: " + str(stat))
	return 0


# Cost in bio-energy to boost a given stat by 1 point from its current value
func costToBoostStatByOne(stat: COMBAT_STAT) -> int:
	return costToBoostStatForValue(stat, getRawStatFromEnumType(stat))


func costToBoostStatBy(stat: COMBAT_STAT, amount: int) -> int:
	
	var result: int = 0
	
	for i in range(amount):
		result += costToBoostStatForValue(stat, getRawStatFromEnumType(stat) + i)
	
	return result


func setStatFromEnumType(stat: COMBAT_STAT, value: int) -> void:
	if stat == Morphose.COMBAT_STAT.HP:
		hp = clampi(value, HP_MINIMUM, HP_CAP)
	elif stat == Morphose.COMBAT_STAT.ATTACK:
		attack = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == Morphose.COMBAT_STAT.DEFENSE:
		defense = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == Morphose.COMBAT_STAT.SENSES:
		senses = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == Morphose.COMBAT_STAT.SPEED:
		speed = clampi(value, STAT_MINIMUM, STAT_CAP)
	elif stat == Morphose.COMBAT_STAT.TECH_POINTS:
		tech_points = clampi(value, TP_MINIMUM, TP_CAP)
	else:
		push_error("Unrecognized status type: " + str(stat))


func getStatMinimumFromEnumType(stat: COMBAT_STAT) -> int:
	if stat == Morphose.COMBAT_STAT.HP:
		return HP_MINIMUM
	elif stat == Morphose.COMBAT_STAT.TECH_POINTS:
		return TP_MINIMUM
	else:
		return STAT_MINIMUM


func getStatMaximumFromEnumType(stat: COMBAT_STAT) -> int:
	if stat == Morphose.COMBAT_STAT.HP:
		return HP_CAP
	elif stat == Morphose.COMBAT_STAT.TECH_POINTS:
		return TP_CAP
	else:
		return STAT_CAP


func canIncreaseStat(stat: COMBAT_STAT) -> bool:
	return bio_energy >= costToBoostStatByOne(stat) and getStatFromEnumType(stat) < getStatMaximumFromEnumType(stat)


func canDecreaseStat(stat: COMBAT_STAT) -> bool:
	return getRawStatFromEnumType(stat) > getStatMinimumFromEnumType(stat)


func statPlusOne(stat: COMBAT_STAT) -> void:
	bio_energy -= costToBoostStatByOne(stat)
	setStatFromEnumType(stat, getRawStatFromEnumType(stat) + 1)


func statMinusOne(stat: COMBAT_STAT) -> void:
	setStatFromEnumType(stat, getRawStatFromEnumType(stat) - 1)
	bio_energy += costToBoostStatByOne(stat)


# Reset all stats to minimum values, uninstall all blueprints, and refund all bio-energy
func liquidateBioEnergy() -> void:
	
	# Set stats to minimum values
	for stat in [Morphose.COMBAT_STAT.HP, Morphose.COMBAT_STAT.ATTACK, Morphose.COMBAT_STAT.DEFENSE, Morphose.COMBAT_STAT.SENSES, Morphose.COMBAT_STAT.SPEED, Morphose.COMBAT_STAT.TECH_POINTS]:
		while getRawStatFromEnumType(stat) > getStatMinimumFromEnumType(stat):
			statMinusOne(stat)

	# Uninstall blueprints
	for blueprint_list in [blueprints_attack, blueprints_support, blueprints_passive]:
		while not blueprint_list.is_empty():
			bio_energy += blueprint_list.pop_front().getBioEnergyCost()
	
	# Remove blueprint slots
	while canRemoveBlueprintSlot():
		removeBlueprintSlot()


func hasAFreeBlueprintSlot() -> bool:
	return allBlueprints().size() < blueprint_slots


# Free: If true, blueprint is installed without paying Muta
func installBlueprint(blueprint, free: bool = false) -> void:
	
	if not hasAFreeBlueprintSlot():
		push_error("Tried to install blueprint on " + name + " with no free slot.")
		return

	uninstallPredecessorsAndSuccessors(blueprint)
	
	var blueprint_list: Array
	
	if blueprint is BlueprintAttack:
		blueprint_list = blueprints_attack
	elif blueprint is BlueprintSupport:
		blueprint_list = blueprints_support
	elif blueprint is BlueprintPassive:
		blueprint_list = blueprints_passive
	
	blueprint_list.append(blueprint)
	blueprint_list.sort_custom(Blueprint.sortBlueprintsAscending)
	
	if not free:
		bio_energy -= blueprint.getBioEnergyCost()


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
		bio_energy += blueprint.getBioEnergyCost()
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
	if name == PARTY_MEMBER_PRIMUS_NAME:
		return blueprint_in.primus_compatible
	elif name == PARTY_MEMBER_DEFECTOR_NAME:
		return blueprint_in.defector_compatible
	elif name == PARTY_MEMBER_SCHOLAR_NAME:
		return blueprint_in.scholar_compatible
	
	push_error("Blueprint compatibility check failed for party member " + name)
	return false


func mutaCostToAddBlueprintSlot() -> int:
	return BASE_ADD_BLUEPRINT_SLOT_MUTA_COST * pow(ADD_BLUEPRINT_COST_MULTIPLIER, blueprint_slots - STARTING_BLUEPRINT_SLOTS)


func atMaxBlueprintSlots() -> bool:
	return blueprint_slots == MAX_BLUEPRINT_SLOTS

func canAddBlueprintSlot() -> bool:
	return not atMaxBlueprintSlots() and bio_energy >= mutaCostToAddBlueprintSlot()


func addBlueprintSlot() -> void:
	if canAddBlueprintSlot():
		bio_energy -= mutaCostToAddBlueprintSlot()
		blueprint_slots += 1
	else:
		push_error("Tried to add blueprint slot at max slots")


func canRemoveBlueprintSlot() -> bool:
	return blueprint_slots > STARTING_BLUEPRINT_SLOTS


func removeBlueprintSlot() -> void:
	if canRemoveBlueprintSlot():
		blueprint_slots -= 1
		bio_energy += mutaCostToAddBlueprintSlot()
		# Remove last blueprint if all slots were used
		while allBlueprints().size() > blueprint_slots:
			uninstallBlueprint(allBlueprints().back())
	else:
		push_error("Tried to remove blueprint slot at min slots")


func giveBioEnergy(muta: int) -> void:
	bio_energy += muta
