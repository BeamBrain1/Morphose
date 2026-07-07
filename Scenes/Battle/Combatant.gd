class_name Combatant

enum STATUS_EFFECT {REGEN, SHARPENED, HARDENED, KEEN, ENERGIZED, FOCUSED}

signal dies

enum ACTION {NULL, BLUEPRINT, WAIT, RUN, PROMPT_PLAYER}

const MAX_STATUS_EFFECT_STACKS: int = 5
const BASE_ACCURACY = 75
const BASE_CRIT_RATE = 5

var name: String = "[NO DATA]"
var max_hp: int = 1
var hp: int = max_hp
var attack: int = 1
var defense: int = 1
var senses: int = 1
var speed: int = 1
var max_tp: int = 1
var tech_points: int = max_tp
#var tp_regen: int = 1

# Negative status effects are just a negative number of stacks of the positive status effect
var regen_stacks: int = 0
var sharpened_stacks: int = 0
var hardened_stacks: int = 0
var keen_stacks: int = 0
var energized_stacks: int = 0
var focused_stacks: int = 0

var gained_regen_on_own_turn: bool = false
var gained_sharpened_on_own_turn: bool = false
var gained_hardened_on_own_turn: bool = false
var gained_keen_on_own_turn: bool = false
var gained_energized_on_own_turn: bool = false
var gained_focused_on_own_turn: bool = false

var accumulated_speed: int = 0

var blueprints_attack: Array[BlueprintAttack] = []
var blueprints_support: Array[BlueprintSupport] = []
var blueprints_passive: Array[BlueprintPassive] = []

# Updates to battle status to be retrieved by battle controller
var battle_messages: Array[String] = []
var marked_defeated: bool = false


func getName() -> String:
	return name


func initializeHP(value: int) -> void:
	max_hp = value
	hp = max_hp


func initializeTP(value: int) -> void:
	max_tp = value
	tech_points = max_tp


func isDefeated() -> bool:
	return hp == 0


func changeHP(amount: int) -> void:
	hp += amount
	hp = clamp(hp, 0, max_hp)
	if isDefeated() and not marked_defeated:
		markDefeated()


func damage(amount: int) -> void:
	var final_amount: int = maxi(amount, 0)
	if final_amount == 0:
		pushBattleMessage("Couldn't pierce " + name + "'s armor.")
	else:
		pushBattleMessage(name + " takes " + str(final_amount) + " damage.")
	changeHP(-1 * final_amount)
	if isDefeated():
		markDefeated()


func heal(amount: int) -> void:
	var final_amount: int = maxi(amount, 0)
	pushBattleMessage(name + " recovers " + str(final_amount) + " HP.")
	changeHP(final_amount)


func getStatusEffectFromEnumType(effect: STATUS_EFFECT) -> int:
	if effect == STATUS_EFFECT.REGEN:
		return regen_stacks
	if effect == STATUS_EFFECT.SHARPENED:
		return sharpened_stacks
	if effect == STATUS_EFFECT.HARDENED:
		return hardened_stacks
	if effect == STATUS_EFFECT.KEEN:
		return keen_stacks
	if effect == STATUS_EFFECT.ENERGIZED:
		return energized_stacks
	if effect == STATUS_EFFECT.FOCUSED:
		return focused_stacks
	push_error("Unrecognized status type: " + str(effect))
	return 0


func getStatusEffectAdjustedAttack() -> int:
	return floori(attack * (1 + sharpened_stacks * 0.15))


func getStatusEffectAdjustedDefense() -> int:
	return floori(defense * (1 + hardened_stacks * 0.15))


func getStatusEffectAdjustedSenses() -> int:
	return floori(senses * (1 + keen_stacks * 0.15))


func getStatusEffectAdjustedSpeed() -> int:
	return floori(speed * (1 + energized_stacks * 0.15))


func getStatusEffectAdjustedTPRegen() -> int:
	return maxi(0, ceili((0.15 * focused_stacks + 1) * getBaseTPRegen()))


func getBaseTPRegen() -> int:
	return ceili(float(max_tp) / 4)


func adjustStatusEffectFromEnumType(effect: STATUS_EFFECT, change: int, self_applied: bool = false) -> void:
	
	var true_change: int = 0
	var old_stacks: int
	var new_stacks: int
	
	if effect == STATUS_EFFECT.REGEN and change != 0:
		old_stacks = regen_stacks
		regen_stacks += change
		regen_stacks = clamp(regen_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = regen_stacks - old_stacks
		new_stacks = regen_stacks
		if new_stacks > 0 and self_applied:
			gained_regen_on_own_turn = true
	elif effect == STATUS_EFFECT.SHARPENED and change != 0:
		old_stacks = sharpened_stacks
		sharpened_stacks += change
		sharpened_stacks = clamp(sharpened_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = sharpened_stacks - old_stacks
		new_stacks = sharpened_stacks
		if new_stacks > 0 and self_applied:
			gained_sharpened_on_own_turn = true
	elif effect == STATUS_EFFECT.HARDENED and change != 0:
		old_stacks = hardened_stacks
		hardened_stacks += change
		hardened_stacks = clamp(hardened_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = hardened_stacks - old_stacks
		new_stacks = hardened_stacks
		if new_stacks > 0 and self_applied:
			gained_hardened_on_own_turn = true
	elif effect == STATUS_EFFECT.KEEN and change != 0:
		old_stacks = keen_stacks
		keen_stacks += change
		keen_stacks = clamp(keen_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = keen_stacks - old_stacks
		new_stacks = keen_stacks
		if new_stacks > 0 and self_applied:
			gained_keen_on_own_turn = true
	elif effect == STATUS_EFFECT.ENERGIZED and change != 0:
		old_stacks = energized_stacks
		energized_stacks += change
		energized_stacks = clamp(energized_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = energized_stacks - old_stacks
		new_stacks = energized_stacks
		if new_stacks > 0 and self_applied:
			gained_energized_on_own_turn = true
	elif effect == STATUS_EFFECT.FOCUSED and change != 0:
		old_stacks = focused_stacks
		focused_stacks += change
		focused_stacks = clamp(focused_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = focused_stacks - old_stacks
		new_stacks = focused_stacks
		if new_stacks > 0 and self_applied:
			gained_focused_on_own_turn = true
	
	if true_change > 0:
		var bad_stacks_shed: int = mini(0, new_stacks) - mini(0, old_stacks)
		var good_stacks_gained: int = maxi(0, new_stacks) - maxi(0, old_stacks)
		if bad_stacks_shed > 0:
			pushBattleMessage(name + " sheds " + str(bad_stacks_shed) + " " + getNegativeStatusEffectString(effect) + ".")
		if good_stacks_gained > 0:
			pushBattleMessage(name + " gains " + str(good_stacks_gained) + " " + getPositiveStatusEffectString(effect) + ".")
	elif true_change < 0:
		var good_stacks_lost: int = maxi(0, old_stacks) - maxi(0, new_stacks)
		var bad_stacks_afflicted: int = mini(0, old_stacks) - mini(0, new_stacks)
		if good_stacks_lost > 0:
			pushBattleMessage(name + " loses " + str(good_stacks_lost) + " " + getPositiveStatusEffectString(effect) + ".")
		if bad_stacks_afflicted > 0:
			pushBattleMessage(name + " suffers " + str(bad_stacks_afflicted) + " " + getNegativeStatusEffectString(effect) + ".")


# Only upwardly adjusts (heals) existing status effects
func healStatusEffectFromEnumType(effect: STATUS_EFFECT, heal_amount: int) -> void:
	
	var true_heal_amount: int = 0
	
	if effect == STATUS_EFFECT.REGEN and regen_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(regen_stacks * -1, heal_amount)
		regen_stacks += true_heal_amount
	elif effect == STATUS_EFFECT.SHARPENED and sharpened_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(sharpened_stacks * -1, heal_amount)
		sharpened_stacks += true_heal_amount
	elif effect == STATUS_EFFECT.HARDENED and hardened_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(hardened_stacks * -1, heal_amount)
		hardened_stacks += true_heal_amount
	elif effect == STATUS_EFFECT.KEEN and keen_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(keen_stacks * -1, heal_amount)
		keen_stacks += true_heal_amount
	elif effect == STATUS_EFFECT.ENERGIZED and energized_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(energized_stacks * -1, heal_amount)
		energized_stacks += true_heal_amount
	elif effect == STATUS_EFFECT.FOCUSED and focused_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(focused_stacks * -1, heal_amount)
		focused_stacks += true_heal_amount
	
	if true_heal_amount > 0:
		pushBattleMessage(name + " sheds " + str(true_heal_amount) + " " + getNegativeStatusEffectString(effect) + ".")

func beginTurn() -> void:
	accumulated_speed = 0
	applyStartOfTurnPassiveBlueprintEffects()
	applyHealingBurning()
	if not isDefeated():
		regenTP()


func endTurn() -> void:
	if not isDefeated():
		shedStatusEffects()
		clearSelfAppliedBuffsThisTurn()


func clearSelfAppliedBuffsThisTurn() -> void:
	gained_regen_on_own_turn = false
	gained_sharpened_on_own_turn = false
	gained_hardened_on_own_turn = false
	gained_keen_on_own_turn = false
	gained_energized_on_own_turn = false
	gained_focused_on_own_turn = false


func applyStartOfTurnPassiveBlueprintEffects() -> void:
	pass


func applyHealingBurning() -> void:
	if getStatusEffectFromEnumType(STATUS_EFFECT.REGEN) != 0:
		var heal_amount: int = maxi(floori(hp/10), 1)
		heal_amount *= getStatusEffectFromEnumType(STATUS_EFFECT.REGEN)
		if heal_amount > 0:
			heal(heal_amount)
		elif heal_amount < 0:
			damage(-1 * heal_amount)


func regenTP() -> void:
	tech_points = clampi(tech_points + getStatusEffectAdjustedTPRegen(), 0, max_tp)


func canUseAbility(tp_cost: int) -> bool:
	return tech_points >= tp_cost


func spendTP(amount: int) -> void:
	tech_points = clampi(tech_points - amount, 0, max_tp)


func shedStatusEffects() -> void:
	for status_effect in [STATUS_EFFECT.REGEN, STATUS_EFFECT.SHARPENED, STATUS_EFFECT.HARDENED, STATUS_EFFECT.KEEN, STATUS_EFFECT.ENERGIZED, STATUS_EFFECT.FOCUSED]:
		if randi() % 2 == 0:
			if getStatusEffectFromEnumType(status_effect) > 0:
				shedBuffIfNotSelfAppliedThisTurn(status_effect)
			elif getStatusEffectFromEnumType(status_effect) < 0:
				adjustStatusEffectFromEnumType(status_effect, 1)


# A character can only shed a buff at the end of turn if they did not self-apply one
func shedBuffIfNotSelfAppliedThisTurn(status_effect: STATUS_EFFECT) -> void:
	if status_effect == STATUS_EFFECT.REGEN and not gained_regen_on_own_turn:
		adjustStatusEffectFromEnumType(status_effect, -1)
	elif status_effect == STATUS_EFFECT.SHARPENED and not gained_sharpened_on_own_turn:
		adjustStatusEffectFromEnumType(status_effect, -1)
	elif status_effect == STATUS_EFFECT.HARDENED and not gained_hardened_on_own_turn:
		adjustStatusEffectFromEnumType(status_effect, -1)
	elif status_effect == STATUS_EFFECT.KEEN and not gained_keen_on_own_turn:
		adjustStatusEffectFromEnumType(status_effect, -1)
	elif status_effect == STATUS_EFFECT.ENERGIZED and not gained_energized_on_own_turn:
		adjustStatusEffectFromEnumType(status_effect, -1)
	elif status_effect == STATUS_EFFECT.FOCUSED and not gained_focused_on_own_turn:
		adjustStatusEffectFromEnumType(status_effect, -1)


func getPositiveStatusEffectString(effect: STATUS_EFFECT) -> String:
	if effect == STATUS_EFFECT.REGEN:
		return "Regen"
	elif effect == STATUS_EFFECT.SHARPENED:
		return "Sharpened"
	elif effect == STATUS_EFFECT.HARDENED:
		return "Hardened"
	elif effect == STATUS_EFFECT.KEEN:
		return "Keen"
	elif effect == STATUS_EFFECT.ENERGIZED:
		return "Energized"
	elif effect == STATUS_EFFECT.FOCUSED:
		return "Focused"
	else:
		push_error("Unrecognized status effect: " + str(effect))
		return "[ERROR]"


func getNegativeStatusEffectString(effect: STATUS_EFFECT) -> String:
	if effect == STATUS_EFFECT.REGEN:
		return "Burning"
	elif effect == STATUS_EFFECT.SHARPENED:
		return "Tranqed"
	elif effect == STATUS_EFFECT.HARDENED:
		return "Acid"
	elif effect == STATUS_EFFECT.KEEN:
		return "Blinded"
	elif effect == STATUS_EFFECT.ENERGIZED:
		return "Slimed"
	elif effect == STATUS_EFFECT.FOCUSED:
		return "Enraged"
	else:
		push_error("Unrecognized status effect: " + str(effect))
		return "[ERROR]"


# builds accumulated speed, used to determine initiative
func generateAccumulatedSpeed() -> void:
	var random_range: int = maxi(getStatusEffectAdjustedSpeed() >> 2, 2)
	var random_factor: int = randi() % random_range
	if randi() % 2 == 0:
		random_factor *= -1
	# Base value of 10 ensures speed doesn't completely dominate in early game
	accumulated_speed += 10 + getStatusEffectAdjustedSpeed() + random_factor


# If Morphose defeated, clear all status effects
func markDefeated():
	if not marked_defeated:
		regen_stacks = 0
		sharpened_stacks = 0
		hardened_stacks = 0
		keen_stacks = 0
		energized_stacks = 0
		focused_stacks = 0
		pushBattleMessage(name + " is defeated!")
		marked_defeated = true
		emit_signal("dies")


func chooseAction() -> ACTION:
	push_error("Oops! You were supposed to override this in the subclass.")
	return ACTION.WAIT


func chooseBlueprint() -> Blueprint:
	push_error("Oops! You were supposed to override this in the subclass.")
	return null


# Choose target for single-target blueprint action
func chooseTarget(blueprint: Blueprint, target_list: Array) -> Combatant:
	push_error("Oops! You were supposed to override this in the subclass.")
	return target_list[0]


# Raw accuracy of an attack, before any defender bonuses apply
func rawAccuracy(blueprint: BlueprintAttack) -> int:
	return BASE_ACCURACY + getStatusEffectAdjustedSenses() + blueprint.accuracy


func hitEvasion() -> int:
	return getStatusEffectAdjustedSpeed()


# Raw accuracy of an attack, before any defender bonuses apply
func rawCritRate(blueprint: BlueprintAttack) -> int:
	return BASE_CRIT_RATE + floori(getStatusEffectAdjustedSenses() / 2) + blueprint.crit_rate


func critEvasion() -> int:
	return floori(getStatusEffectAdjustedSpeed() / 2)


# Generates raw damage, before any defenses applied, for a given attack made by this character
func rawAttackDamage(blueprint: BlueprintAttack) -> int:

	if blueprint.damageless:
		return 0

	var base_damage: int = blueprint.base_damage

	if not blueprint.fixed_damage:
		base_damage += getStatusEffectAdjustedAttack()

	var random_damage: int = (base_damage >> 2) + 2
	random_damage = randi() % (random_damage)

	if randi() % 2 == 0:
		random_damage *= -1

	return base_damage + random_damage


func receiveAttack(blueprint: BlueprintAttack, raw_damage: int, crit: bool = false) -> void:

	if not blueprint.damageless:
		var damage_amt: int = raw_damage
		if not blueprint.fixed_damage:
			damage_amt -= getStatusEffectAdjustedDefense()
		damage(damage_amt)
	
	
	
	if not isDefeated():
		if crit:
			adjustStatusEffectFromEnumType(STATUS_EFFECT.REGEN, -1 * critAdjustedStatusValue(blueprint.burning))
			adjustStatusEffectFromEnumType(STATUS_EFFECT.SHARPENED, -1 * critAdjustedStatusValue(blueprint.tranqed))
			adjustStatusEffectFromEnumType(STATUS_EFFECT.HARDENED, -1 * critAdjustedStatusValue(blueprint.acid))
			adjustStatusEffectFromEnumType(STATUS_EFFECT.KEEN, -1 * critAdjustedStatusValue(blueprint.blind))
			adjustStatusEffectFromEnumType(STATUS_EFFECT.ENERGIZED, -1 * critAdjustedStatusValue(blueprint.slimed))
			adjustStatusEffectFromEnumType(STATUS_EFFECT.FOCUSED, -1 * critAdjustedStatusValue(blueprint.rage))
		else:
			adjustStatusEffectFromEnumType(STATUS_EFFECT.REGEN, -1 * blueprint.burning)
			adjustStatusEffectFromEnumType(STATUS_EFFECT.SHARPENED, -1 * blueprint.tranqed)
			adjustStatusEffectFromEnumType(STATUS_EFFECT.HARDENED, -1 * blueprint.acid)
			adjustStatusEffectFromEnumType(STATUS_EFFECT.KEEN, -1 * blueprint.blind)
			adjustStatusEffectFromEnumType(STATUS_EFFECT.ENERGIZED, -1 * blueprint.slimed)
			adjustStatusEffectFromEnumType(STATUS_EFFECT.FOCUSED, -1 * blueprint.rage)


# Status effect crits deal 1 additional level of the status effect
func critAdjustedStatusValue(value_in: int) -> int:
	# If attack does not apply status effect to begin with, don't 
	if value_in == 0:
		return 0
	return value_in + 1


# self_applied: Is the combatant applying this support to themselves?
func receiveSupport(blueprint: BlueprintSupport, self_applied: bool = false) -> void:
	if blueprint.base_healing != 0:
		var random_healing: int = maxi(2, (blueprint.base_healing >> 2) + 1)
		random_healing = randi() % random_healing
		if randi() % 2 == 0:
			random_healing *= -1
		heal(blueprint.base_healing + random_healing)

	healStatusEffectFromEnumType(STATUS_EFFECT.REGEN, blueprint.heal_burning)
	healStatusEffectFromEnumType(STATUS_EFFECT.SHARPENED, blueprint.heal_tranqed)
	healStatusEffectFromEnumType(STATUS_EFFECT.HARDENED, blueprint.heal_acid)
	healStatusEffectFromEnumType(STATUS_EFFECT.KEEN, blueprint.heal_blind)
	healStatusEffectFromEnumType(STATUS_EFFECT.ENERGIZED, blueprint.heal_slimed)
	healStatusEffectFromEnumType(STATUS_EFFECT.FOCUSED, blueprint.heal_rage)

	adjustStatusEffectFromEnumType(STATUS_EFFECT.REGEN, blueprint.regen, self_applied)
	adjustStatusEffectFromEnumType(STATUS_EFFECT.SHARPENED, blueprint.sharpened, self_applied)
	adjustStatusEffectFromEnumType(STATUS_EFFECT.HARDENED, blueprint.hardened, self_applied)
	adjustStatusEffectFromEnumType(STATUS_EFFECT.KEEN, blueprint.keen, self_applied)
	adjustStatusEffectFromEnumType(STATUS_EFFECT.ENERGIZED, blueprint.energized, self_applied)
	adjustStatusEffectFromEnumType(STATUS_EFFECT.FOCUSED, blueprint.focused, self_applied)


func pushBattleMessage(update: String) -> void:
	battle_messages.append(update)


func retrieveBattleMessages() -> Array[String]:
	var result: Array[String] = []
	while not battle_messages.is_empty():
		result.append(battle_messages.pop_front())
	return result


# Returns a list of all blueprints installed for this character
func allBlueprints() -> Array:
	var result = []
	for blueprint in blueprints_attack:
		result.append(blueprint)
	for blueprint in blueprints_support:
		result.append(blueprint)
	for blueprint in blueprints_passive:
		result.append(blueprint)
	return result


func setInitialHP(hp_in: int):
	max_hp = hp_in
	hp = max_hp


func setInitialTP(tp_in: int):
	max_tp = tp_in
	tech_points = max_tp


func giveBlueprint(blueprint) -> void:
	if blueprint is BlueprintAttack:
		blueprints_attack.append(blueprint)
		blueprints_attack.sort_custom(Blueprint.sortBlueprintsAscending)
	elif blueprint is BlueprintSupport:
		blueprints_support.append(blueprint)
		blueprints_support.sort_custom(Blueprint.sortBlueprintsAscending)
	elif blueprint is BlueprintPassive:
		blueprints_passive.append(blueprint)
		blueprints_passive.sort_custom(Blueprint.sortBlueprintsAscending)
	else:
		push_error("Attempted to give " + name + " unrecognized blueprint " + blueprint)


# Returns a line-separated list of Morphose's stats
func statDump() -> String:
	var result = name
	result += "\n" + "HP: " + str(hp) + "/" + str(max_hp) +  " > " + str(regen_stacks)
	result += "\n" + "TP: " + str(tech_points) + "/" + str(max_tp)
	result += "\n" + "  Rcv: " + str(getStatusEffectAdjustedTPRegen()) + " (" + str(getBaseTPRegen()) + ") > " + str(focused_stacks)
	result += "\n" + "Attack: " + str(getStatusEffectAdjustedAttack()) + " (" + str(attack) + ") > " + str(sharpened_stacks)
	result += "\n" + "Defense: " + str(getStatusEffectAdjustedDefense()) + " (" + str(defense) + ") > " + str(hardened_stacks)
	result += "\n" + "Senses: " + str(getStatusEffectAdjustedSenses()) + " (" + str(senses) + ") > " + str(keen_stacks)
	result += "\n" + "Speed: " + str(getStatusEffectAdjustedSpeed()) + " (" + str(speed) + ") > " + str(energized_stacks)
	result += "\n" + "AccumSpeed: " + str(accumulated_speed)
	return result


# Possible actions are any it has the TP for
func getPossibleBlueprintActions() -> Array:

	var result: Array = []

	for blueprint_list in [blueprints_attack, blueprints_support]:
		for blueprint in blueprint_list:
			if blueprint.tp_cost <= tech_points:
				result.append(blueprint)

	return result


func getPossibleAttackActions() -> Array[BlueprintAttack]:
	var result: Array[BlueprintAttack] = []

	for blueprint in blueprints_attack:
		if blueprint.tp_cost <= tech_points:
			result.append(blueprint)

	return result


func canAttack():
	return not getPossibleAttackActions().is_empty()


func hasAttackBlueprints():
	return not blueprints_attack.is_empty()


func getPossibleSupportActions() -> Array[BlueprintSupport]:
	var result: Array[BlueprintSupport] = []

	for blueprint in blueprints_support:
		if blueprint.tp_cost <= tech_points:
			result.append(blueprint)

	return result


func canSupport() -> bool:
	return not getPossibleSupportActions().is_empty()


func hasSupportBlueprints() -> bool:
	return not blueprints_support.is_empty()


func wait() -> void:
	pushBattleMessage(name + " waits.")


func run() -> void:
	pushBattleMessage("The party runs away.")


func isValidSupportTarget(blueprint: BlueprintSupport) -> bool:
	return (isDefeated() and blueprint.can_revive) or (not isDefeated() and not blueprint.can_revive)
