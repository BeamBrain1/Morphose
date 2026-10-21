class_name Combatant

enum STATUS_EFFECT {REGEN, SHARPENED, HARDENED, KEEN, ENERGIZED, FOCUSED}

enum ACTION {NULL, BLUEPRINT, WAIT, RUN, PROMPT_PLAYER}

const MAX_STATUS_EFFECT_STACKS: int = 6
const DEFAULT_ACCURACY = 80						# Odds to hit if attacker accuracy = defender evasion
const DEFAULT_CRIT_RATE = 10					# Odds to crit if attacker accuracy = defender evasion
const BASE_ACCURACY_AND_EVADE = 10				# Base accuracy/evasion score before applying stats
												# 	Stops Senses/Speed from completely dominating early game
const BASE_CRIT_RATE_AND_CRIT_EVADE = 10		# Ditto for crit rate/evade

const MIN_ACCURACY: int = 1
const MAX_ACCURACY: int = 99
const MIN_CRIT: int = 1
const MAX_CRIT: int = 90

const BASE_ACCUM_SPEED_GAIN = 10	# Per-turn base accumulated speed, onto which stat-derived speed is added
									# 	Stops speed from completely dominating early game

const STATUS_STACK_DEFAULT_MULTIPLIER: float = 0.15
const SPEED_STACK_MULTIPLIER: float = 0.10

var hp
var tech_points

# Negative status effects are just a negative number of stacks of the positive status effect
var regen_stacks: int = 0
var sharpened_stacks: int = 0
var hardened_stacks: int = 0
var keen_stacks: int = 0
var energized_stacks: int = 0
var focused_stacks: int = 0

var buffed_regen_on_own_turn: bool = false
var buffed_sharpened_on_own_turn: bool = false
var buffed_hardened_on_own_turn: bool = false
var buffed_keen_on_own_turn: bool = false
var buffed_energized_on_own_turn: bool = false
var buffed_focused_on_own_turn: bool = false

var accumulated_speed: int = 0
var first_accumulated_speed_set = false

const BURNING_STACK_DIVISION: int = 12
const HEALING_STACK_DIVISION: int = 12

var never_crits: bool = false	# Avoids enemies oneshotting Primus in early game

# Updates to battle status to be retrieved by battle controller
var battle_messages: Array[String] = []
var marked_defeated: bool = false
var morphose	# The base Morphose from which this combatant draws its unmodified stats
				# For party combatants, this is PartyMember. For enemies, it's EnemyType

const RECOMBINE_STACKS: int = 6

# Variables below are for accumulated hits/crits/etc. from single attacks
var accumulated_hits: int = 0
var accumulated_crits: int = 0
var accumulated_damage: int = 0
var accumulated_burn_stacks: int = 0
var accumulated_tranqed_stacks: int = 0
var accumulated_acid_stacks: int = 0
var accumulated_blind_stacks: int = 0
var accumulated_slimed_stacks: int = 0
var accumulated_rage_stacks: int = 0


func _init(morphose_in):
	morphose = morphose_in
	initializeHP()
	initializeTP()


func getName() -> String:
	return morphose.name.to_upper()


func initializeHP() -> void:
	hp = getMaxHP()


func initializeTP() -> void:
	tech_points = getMaxTP()


func getMaxHP() -> int:
	return morphose.getStatFromEnumType(Morphose.COMBAT_STAT.HP)


func getMaxTP() -> int:
	return morphose.getStatFromEnumType(Morphose.COMBAT_STAT.TECH_POINTS)


func isDefeated() -> bool:
	return hp == 0


func changeHP(amount: int) -> void:
	hp += amount
	hp = clamp(hp, 0, getMaxHP())


func setHP(amount: int) -> void:
	hp = clamp(amount, 0, getMaxHP())


func damage(amount: int) -> void:
	var final_amount: int = maxi(amount, 0)
	changeHP(-1 * final_amount)


func pushDamageMessage(amount: int) -> void:
	if amount == 0:
		pushBattleMessage("Couldn't pierce " + getName() + " armor.")
	else:
		pushBattleMessage(getName() + " takes " + str(amount) + " damage.")


func pushBurningMessage(amount: int) -> void:
	pushBattleMessage(getName() + " burns for " + str(amount) + " damage.")


func pushHealMessage(amount: int) -> void:
	var final_amount: int = maxi(amount, 0)
	if marked_defeated:
		pushBattleMessage(getName() + " revives with " + str(final_amount) + " HP.")
	else:
		pushBattleMessage(getName() + " recovers " + str(final_amount) + " HP.")
	changeHP(final_amount)
	marked_defeated = false


func heal(amount: int) -> void:
	var final_amount: int = maxi(amount, 0)
	pushBattleMessage(getName() + " recovers " + str(final_amount) + " HP.")
	changeHP(final_amount)
	marked_defeated = false


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


func setStatusEffectFromEnumType(effect: STATUS_EFFECT, value: int, self_applied: bool = false) -> void:
	if effect == STATUS_EFFECT.REGEN:
		regen_stacks = value
		if self_applied and value > 0:
			buffed_regen_on_own_turn = true
	elif effect == STATUS_EFFECT.SHARPENED:
		sharpened_stacks = value
		if self_applied and value > 0:
			buffed_sharpened_on_own_turn = true
	elif effect == STATUS_EFFECT.HARDENED:
		hardened_stacks = value
		if self_applied and value > 0:
			buffed_hardened_on_own_turn = true
	elif effect == STATUS_EFFECT.KEEN:
		keen_stacks = value
		if self_applied and value > 0:
			buffed_keen_on_own_turn = true
	elif effect == STATUS_EFFECT.ENERGIZED:
		energized_stacks = value
		if self_applied and value > 0:
			buffed_energized_on_own_turn = true
	elif effect == STATUS_EFFECT.FOCUSED:
		focused_stacks = value
		if self_applied and value > 0:
			buffed_focused_on_own_turn = true
	else:
		push_error("Unrecognized status type: " + str(effect))


func getStatusEffectAdjustedAttack() -> int:
	return floori(morphose.getStatFromEnumType(Morphose.COMBAT_STAT.ATTACK) * (1 + sharpened_stacks * STATUS_STACK_DEFAULT_MULTIPLIER))


func getStatusEffectAdjustedDefense() -> int:
	return floori(morphose.getStatFromEnumType(Morphose.COMBAT_STAT.DEFENSE) * (1 + hardened_stacks * STATUS_STACK_DEFAULT_MULTIPLIER))


func getStatusEffectAdjustedSenses() -> int:
	return floori(morphose.getStatFromEnumType(Morphose.COMBAT_STAT.SENSES) * (1 + keen_stacks * STATUS_STACK_DEFAULT_MULTIPLIER))


# Speed stacks are less potent to mitigate action economy (dis)advantage
func getStatusEffectAdjustedSpeed() -> int:
	return floori(morphose.getStatFromEnumType(Morphose.COMBAT_STAT.SPEED) * (1 + energized_stacks * SPEED_STACK_MULTIPLIER))


func getStatusEffectAdjustedTPRegen() -> int:
	return maxi(0, ceili((STATUS_STACK_DEFAULT_MULTIPLIER * focused_stacks + 1) * getBaseTPRegen()))


func getBaseTPRegen() -> int:
	return ceili(float(morphose.getStatFromEnumType(Morphose.COMBAT_STAT.TECH_POINTS)) / 4)


# self_applied_via_action: Was this Morphose's applied to themself by an action taken on their current turn?
func adjustStatusEffectFromEnumType(effect: STATUS_EFFECT, change: int, self_applied_via_action: bool = false) -> void:
	
	var true_change: int = 0
	var old_stacks: int
	var new_stacks: int
	
	if effect == STATUS_EFFECT.REGEN and change != 0:
		old_stacks = regen_stacks
		regen_stacks += change		# Regen/burn unaffected by immunity
		regen_stacks = clamp(regen_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = regen_stacks - old_stacks
		new_stacks = regen_stacks
		if new_stacks != 0 and self_applied_via_action and change > 0:
			buffed_regen_on_own_turn = true
	elif effect == STATUS_EFFECT.SHARPENED and change != 0:
		old_stacks = sharpened_stacks
		sharpened_stacks += change
		sharpened_stacks = clamp(sharpened_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = sharpened_stacks - old_stacks
		new_stacks = sharpened_stacks
		if new_stacks != 0 and self_applied_via_action and change > 0:
			buffed_sharpened_on_own_turn = true
	elif effect == STATUS_EFFECT.HARDENED and change != 0:
		old_stacks = hardened_stacks
		hardened_stacks += change
		hardened_stacks = clamp(hardened_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = hardened_stacks - old_stacks
		new_stacks = hardened_stacks
		if new_stacks != 0 and self_applied_via_action and change > 0:
			buffed_hardened_on_own_turn = true
	elif effect == STATUS_EFFECT.KEEN and change != 0:
		old_stacks = keen_stacks
		keen_stacks += change
		keen_stacks = clamp(keen_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = keen_stacks - old_stacks
		new_stacks = keen_stacks
		if new_stacks != 0 and self_applied_via_action and change > 0:
			buffed_keen_on_own_turn = true
	elif effect == STATUS_EFFECT.ENERGIZED and change != 0:
		old_stacks = energized_stacks
		energized_stacks += change
		energized_stacks = clamp(energized_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = energized_stacks - old_stacks
		new_stacks = energized_stacks
		if new_stacks != 0 and self_applied_via_action and change > 0:
			buffed_energized_on_own_turn = true
	elif effect == STATUS_EFFECT.FOCUSED and change != 0:
		old_stacks = focused_stacks
		focused_stacks += change
		focused_stacks = clamp(focused_stacks, -1 * MAX_STATUS_EFFECT_STACKS, MAX_STATUS_EFFECT_STACKS)
		true_change = focused_stacks - old_stacks
		new_stacks = focused_stacks
		if new_stacks != 0 and self_applied_via_action and change > 0:
			buffed_focused_on_own_turn = true
	
	if true_change > 0:
		var bad_stacks_shed: int = mini(0, new_stacks) - mini(0, old_stacks)
		var good_stacks_gained: int = maxi(0, new_stacks) - maxi(0, old_stacks)		
	elif true_change < 0:
		var good_stacks_lost: int = maxi(0, old_stacks) - maxi(0, new_stacks)
		var bad_stacks_afflicted: int = mini(0, old_stacks) - mini(0, new_stacks)


# Only upwardly adjusts (heals) existing status effects
func healStatusEffectFromEnumType(effect: STATUS_EFFECT, heal_amount: int) -> void:
	
	var true_heal_amount: int = 0
	
	if effect == STATUS_EFFECT.REGEN and regen_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(regen_stacks * -1, heal_amount)
		regen_stacks += true_heal_amount
		pushBattleMessage(getName() + " shed " + str(true_heal_amount) + " " + getNegativeStatusEffectString(STATUS_EFFECT.REGEN))
	elif effect == STATUS_EFFECT.SHARPENED and sharpened_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(sharpened_stacks * -1, heal_amount)
		sharpened_stacks += true_heal_amount
		pushBattleMessage(getName() + " shed " + str(true_heal_amount) + " " + getNegativeStatusEffectString(STATUS_EFFECT.SHARPENED))
	elif effect == STATUS_EFFECT.HARDENED and hardened_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(hardened_stacks * -1, heal_amount)
		hardened_stacks += true_heal_amount
		pushBattleMessage(getName() + " shed " + str(true_heal_amount) + " " + getNegativeStatusEffectString(STATUS_EFFECT.HARDENED))
	elif effect == STATUS_EFFECT.KEEN and keen_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(keen_stacks * -1, heal_amount)
		keen_stacks += true_heal_amount
		pushBattleMessage(getName() + " shed " + str(true_heal_amount) + " " + getNegativeStatusEffectString(STATUS_EFFECT.KEEN))
	elif effect == STATUS_EFFECT.ENERGIZED and energized_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(energized_stacks * -1, heal_amount)
		energized_stacks += true_heal_amount
		pushBattleMessage(getName() + " shed " + str(true_heal_amount) + " " + getNegativeStatusEffectString(STATUS_EFFECT.ENERGIZED))
	elif effect == STATUS_EFFECT.FOCUSED and focused_stacks < 0 and heal_amount != 0:
		true_heal_amount = mini(focused_stacks * -1, heal_amount)
		focused_stacks += true_heal_amount
		pushBattleMessage(getName() + " shed " + str(true_heal_amount) + " " + getNegativeStatusEffectString(STATUS_EFFECT.FOCUSED))
	

func beginTurn() -> void:
	accumulated_speed = 0
	applyStartOfTurnPassiveBlueprintEffects()
	applyHealingBurning()
	shedNegativeStatusEffects()
	if not isDefeated():
		regenTP()


func endTurn() -> void:
	if not isDefeated():
		shedPositiveStatusEffects()
		clearSelfAppliedBuffFlags()


func clearSelfAppliedBuffFlags() -> void:
	buffed_regen_on_own_turn = false
	buffed_sharpened_on_own_turn = false
	buffed_hardened_on_own_turn = false
	buffed_keen_on_own_turn = false
	buffed_energized_on_own_turn = false
	buffed_focused_on_own_turn = false


func applyStartOfTurnPassiveBlueprintEffects() -> void:
	pass


func applyHealingBurning() -> void:
	if getStatusEffectFromEnumType(STATUS_EFFECT.REGEN) != 0:
		var healing: bool = getStatusEffectFromEnumType(STATUS_EFFECT.REGEN) > 0
		var change_amount: int = getMaxHP() * abs(getStatusEffectFromEnumType(STATUS_EFFECT.REGEN))
		
		if healing:
			change_amount = maxi(floori(change_amount/HEALING_STACK_DIVISION), 1)
			heal(change_amount)
			pushHealMessage(change_amount)
		else:
			change_amount = maxi(floori(change_amount/BURNING_STACK_DIVISION), 1)
			if morphose.hasPassiveBlueprintWithSpecial("HydroCoat"):
				change_amount *= 4 - morphose.passiveBlueprintTier("HydroCoat")
				change_amount /= 4
				change_amount = maxi(change_amount, 1)
			damage(change_amount)
			pushBurningMessage(change_amount)
			if isDefeated() and not marked_defeated:
				markDefeated()


func regenTP() -> void:
	tech_points = clampi(tech_points + getStatusEffectAdjustedTPRegen(), 0, getMaxTP())


func spendTP(amount: int) -> void:
	tech_points = clampi(tech_points - amount, 0, getMaxTP())


func shedPositiveStatusEffects() -> void:
	for status_effect in [STATUS_EFFECT.REGEN, STATUS_EFFECT.SHARPENED, STATUS_EFFECT.HARDENED, STATUS_EFFECT.KEEN, STATUS_EFFECT.ENERGIZED, STATUS_EFFECT.FOCUSED]:
		if randi() % 2 == 0:
			if getStatusEffectFromEnumType(status_effect) > 0:
				if shedBuffIfNotSelfAppliedThisTurn(status_effect):
					pushBattleMessage(getName() + " loses 1 " + getPositiveStatusEffectString(status_effect) + ".")


func shedNegativeStatusEffects() -> void:
	
	var num_sheds: int = 1
	
	if morphose.hasPassiveBlueprintWithSpecial("Molt"):
		num_sheds += morphose.passiveBlueprintTier("Molt")
	
	for i in range(num_sheds):
		var successful_sheds: int = 0
		for status_effect in [STATUS_EFFECT.REGEN, STATUS_EFFECT.SHARPENED, STATUS_EFFECT.HARDENED, STATUS_EFFECT.KEEN, STATUS_EFFECT.ENERGIZED, STATUS_EFFECT.FOCUSED]:
			if randi() % 2 == 0:
				if getStatusEffectFromEnumType(status_effect) < 0:
					successful_sheds += 1
					shedDebuff(status_effect)
			if successful_sheds != 0:
				pushBattleMessage(getName() + " sheds " + str(successful_sheds) + " " + getNegativeStatusEffectString(status_effect) + ".")


# A character can only shed a buff at the end of turn if they did not self-apply stacks of it
# Returns true if the buff is shed
func shedBuffIfNotSelfAppliedThisTurn(status_effect: STATUS_EFFECT) -> bool:
	if getStatusEffectFromEnumType(status_effect) > 0:
		if status_effect == STATUS_EFFECT.REGEN and not buffed_regen_on_own_turn:
			adjustStatusEffectFromEnumType(status_effect, -1)
			return true
		elif status_effect == STATUS_EFFECT.SHARPENED and not buffed_sharpened_on_own_turn:
			adjustStatusEffectFromEnumType(status_effect, -1)
			return true
		elif status_effect == STATUS_EFFECT.HARDENED and not buffed_hardened_on_own_turn:
			adjustStatusEffectFromEnumType(status_effect, -1)
			return true
		elif status_effect == STATUS_EFFECT.KEEN and not buffed_keen_on_own_turn:
			adjustStatusEffectFromEnumType(status_effect, -1)
			return true
		elif status_effect == STATUS_EFFECT.ENERGIZED and not buffed_energized_on_own_turn:
			adjustStatusEffectFromEnumType(status_effect, -1)
			return true
		elif status_effect == STATUS_EFFECT.FOCUSED and not buffed_focused_on_own_turn:
			adjustStatusEffectFromEnumType(status_effect, -1)
			return true
	return false


# A character can only shed a debuff at the end of turn if they did not self-apply stacks of it
func shedDebuff(status_effect: STATUS_EFFECT) -> void:
	adjustStatusEffectFromEnumType(status_effect, +1)


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
	if morphose.hasPassiveBlueprintWithSpecial("1stStrike") and not first_accumulated_speed_set:
		accumulated_speed = 9999
	else:
		var default_accum_speed: int = getStatusEffectAdjustedSpeed() / 4
		var random_range: int = maxi(default_accum_speed / 4, 2)
		var random_factor: int = randi() % random_range
		if randi() % 2 == 0:
			random_factor *= -1
		# Base value ensures speed doesn't completely dominate in early game
		accumulated_speed += maxi(1, BASE_ACCUM_SPEED_GAIN + default_accum_speed + random_factor)
		if morphose.hasPassiveBlueprintWithSpecial("Alert") and not first_accumulated_speed_set:
			accumulated_speed += getBlueprint("Alert").value
	first_accumulated_speed_set = true


# If Morphose defeated, clear all status effects
func markDefeated():
	if not marked_defeated:
		tech_points = 0
		regen_stacks = 0
		sharpened_stacks = 0
		hardened_stacks = 0
		keen_stacks = 0
		energized_stacks = 0
		focused_stacks = 0
		pushBattleMessage(getName() + " is defeated!")
		marked_defeated = true


# Raw accuracy of an attack, before any defender bonuses apply
func attackAccuracy(blueprint: BlueprintAttack) -> int:
	return BASE_ACCURACY_AND_EVADE + getStatusEffectAdjustedSenses() + blueprint.accuracy


func hitEvasion() -> int:
	return BASE_ACCURACY_AND_EVADE + maxi(1, getStatusEffectAdjustedSpeed())


# Raw accuracy of an attack, before any defender bonuses apply
func attackCritRate(blueprint: BlueprintAttack) -> int:
	return BASE_CRIT_RATE_AND_CRIT_EVADE + getStatusEffectAdjustedSenses() + blueprint.crit_rate


func critEvasion() -> int:
	return BASE_CRIT_RATE_AND_CRIT_EVADE + maxi(1, getStatusEffectAdjustedSpeed())


# Hit and crit rates are percentage based
func attackHits(blueprint: BlueprintAttack, target) -> bool:
	if blueprint.always_hit:
		return true
	
	var accuracy: int = clampi(DEFAULT_ACCURACY * attackAccuracy(blueprint) / maxi(1, target.hitEvasion()), MIN_ACCURACY, MAX_ACCURACY)
	return randi() % 100 < accuracy


func attackCrits(blueprint: BlueprintAttack, target) -> bool:
	if blueprint.always_hit or never_crits:
		return false
	var crit_rate = clampi(DEFAULT_CRIT_RATE + 3 * ((DEFAULT_CRIT_RATE * attackCritRate(blueprint) / target.critEvasion()) - DEFAULT_CRIT_RATE), MIN_CRIT, MAX_CRIT)
	return randi() % 100 < crit_rate


# Generates raw damage, before any defenses applied, for a given attack made by this character
func rawAttackDamage(blueprint: BlueprintAttack) -> int:

	if blueprint.damageless:
		return 0

	var base_damage: int = blueprint.base_damage

	if not blueprint.fixed_damage:
		base_damage += getStatusEffectAdjustedAttack()

	var random_damage: int = maxi(2, base_damage >> 3)
	random_damage = randi() % (random_damage)

	if randi() % 2 == 0:
		random_damage *= -1

	return base_damage + random_damage


# blueprint: Blueprint of attack
# raw_damage: damage before defense applied
# crit: Whether attack was a critical hit
# final_hit: Whether attack was a final hit (if false, attack is non-final hit in multi-hit attack
func receiveHit(blueprint: BlueprintAttack, raw_damage: int, crit: bool = false) -> void:

	accumulated_hits += 1
	if crit:
		accumulated_crits += 1

	if blueprint.special.matchn("instakill"):
		setHP(0)
		return
	elif not blueprint.damageless:
		var damage_amt: int = raw_damage
		if not blueprint.fixed_damage:
			damage_amt -= getStatusEffectAdjustedDefense()
		damage_amt = max(damage_amt, 0)
		damage(damage_amt)
		accumulated_damage += damage_amt
	
	if not isDefeated():
		adjustStatusEffectFromEnumType(STATUS_EFFECT.REGEN, -1 * adjustedDebuffStacksInflicted(blueprint.burning, crit))
		accumulated_burn_stacks += adjustedDebuffStacksInflicted(blueprint.burning, crit)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.SHARPENED, -1 * adjustedDebuffStacksInflicted(blueprint.tranqed, crit))
		accumulated_tranqed_stacks += adjustedDebuffStacksInflicted(blueprint.tranqed, crit)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.HARDENED, -1 * adjustedDebuffStacksInflicted(blueprint.acid, crit))
		accumulated_acid_stacks += adjustedDebuffStacksInflicted(blueprint.acid, crit)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.KEEN, -1 * adjustedDebuffStacksInflicted(blueprint.blind, crit))
		accumulated_blind_stacks += adjustedDebuffStacksInflicted(blueprint.blind, crit)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.ENERGIZED, -1 * adjustedDebuffStacksInflicted(blueprint.slimed, crit))
		accumulated_slimed_stacks += adjustedDebuffStacksInflicted(blueprint.slimed, crit)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.FOCUSED, -1 * adjustedDebuffStacksInflicted(blueprint.rage, crit))
		accumulated_rage_stacks += adjustedDebuffStacksInflicted(blueprint.rage, crit)


# Returns amount of damage received.
func finishReceivingAttack(damageless: bool) -> int:
	if accumulated_hits == 0:
		pushBattleMessage("Missed!")
	else:
		var hit_and_crit_string: String = ""
		hit_and_crit_string += str(accumulated_hits) + " "
		if accumulated_hits == 1:
			hit_and_crit_string += "hit"
		else:
			hit_and_crit_string += "hits"
		if accumulated_crits > 0:
			hit_and_crit_string += ", " + str(accumulated_crits) + " "
			hit_and_crit_string += "critical"
			
		hit_and_crit_string += "."
		pushBattleMessage(hit_and_crit_string)
		if not damageless:
			pushDamageMessage(accumulated_damage)
		if isDefeated() and not marked_defeated:
			markDefeated()
		
		pushStatusChangesBattleMessages(accumulated_burn_stacks * -1, accumulated_tranqed_stacks * -1, accumulated_acid_stacks * -1, accumulated_blind_stacks * -1, accumulated_slimed_stacks * -1, accumulated_rage_stacks * -1)

	# Reset accumulated received attack stats
	var damage_received = accumulated_damage
	accumulated_hits = 0
	accumulated_crits = 0
	accumulated_damage = 0
	accumulated_burn_stacks = 0
	accumulated_tranqed_stacks = 0
	accumulated_acid_stacks = 0
	accumulated_blind_stacks = 0
	accumulated_slimed_stacks = 0
	accumulated_rage_stacks = 0
	return damage_received


func pushStatusChangesBattleMessages(regen_stacks: int, sharpened_stacks: int, hardened_stacks: int, keen_stacks: int, energized_stacks: int, focused_stacks: int) -> void:
	if regen_stacks > 0:
		pushBattleMessage(getName() + " gains " + str(regen_stacks) + " " + getPositiveStatusEffectString(Combatant.STATUS_EFFECT.REGEN) + ".")
	elif regen_stacks < 0:
		pushBattleMessage(getName() + " suffers " + str(regen_stacks * -1) + " " +getNegativeStatusEffectString(Combatant.STATUS_EFFECT.REGEN) + ".")
	
	if sharpened_stacks > 0:
		pushBattleMessage(getName() + " gains " + str(sharpened_stacks) + " " +getPositiveStatusEffectString(Combatant.STATUS_EFFECT.SHARPENED) + ".")
	elif sharpened_stacks < 0:
		pushBattleMessage(getName() + " suffers " + str(sharpened_stacks * -1) + " " +getNegativeStatusEffectString(Combatant.STATUS_EFFECT.SHARPENED) + ".")
	
	if hardened_stacks > 0:
		pushBattleMessage(getName() + " gains " + str(hardened_stacks) + " " +getPositiveStatusEffectString(Combatant.STATUS_EFFECT.HARDENED) + ".")
	elif hardened_stacks < 0:
		pushBattleMessage(getName() + " suffers " + str(hardened_stacks * -1) + " " +getNegativeStatusEffectString(Combatant.STATUS_EFFECT.HARDENED) + ".")
	
	if keen_stacks > 0:
		pushBattleMessage(getName() + " gains " + str(keen_stacks) + " " +getPositiveStatusEffectString(Combatant.STATUS_EFFECT.KEEN) + ".")
	elif keen_stacks < 0:
		pushBattleMessage(getName() + " suffers " + str(keen_stacks * -1) + " " +getNegativeStatusEffectString(Combatant.STATUS_EFFECT.KEEN) + ".")
	
	if energized_stacks > 0:
		pushBattleMessage(getName() + " gains " + str(energized_stacks) + " " +getPositiveStatusEffectString(Combatant.STATUS_EFFECT.ENERGIZED) + ".")
	elif energized_stacks < 0:
		pushBattleMessage(getName() + " suffers " + str(energized_stacks * -1) + " " +getNegativeStatusEffectString(Combatant.STATUS_EFFECT.ENERGIZED) + ".")
	
	if focused_stacks > 0:
		pushBattleMessage(getName() + " gains " + str(focused_stacks) + " " +getPositiveStatusEffectString(Combatant.STATUS_EFFECT.FOCUSED) + ".")
	elif focused_stacks < 0:
		pushBattleMessage(getName() + " suffers " + str(focused_stacks * -1) + " " +getNegativeStatusEffectString(Combatant.STATUS_EFFECT.FOCUSED) + ".")


# Final amount of debuff stacks applied after factoring in Immunity blueprint (if present) and crit
func adjustedDebuffStacksInflicted(value_in: int, crit: bool = false) -> int:
	# If attack does not apply status effect to begin with, don't 
	if value_in == 0:
		return 0
	var result = value_in
	if crit:
		result += 1
	if morphose.hasPassiveBlueprintWithSpecial("Immunity"):
		result -= getBlueprint("Immunity").tier
	
	return maxi(result, 0)


# self_applied: Is the combatant applying this support to themselves?
func receiveSupport(blueprint: BlueprintSupport, self_applied: bool = false) -> void:
	
	if blueprint.special.matchn("RECOMBINE"):
		receiveRecombination(self_applied)
		return
	else:
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
		
		adjustStatusEffectFromEnumType(STATUS_EFFECT.REGEN, -1 * adjustedDebuffStacksInflicted(blueprint.burning), self_applied)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.SHARPENED, -1 * adjustedDebuffStacksInflicted(blueprint.tranqed), self_applied)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.HARDENED, -1 * adjustedDebuffStacksInflicted(blueprint.acid), self_applied)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.KEEN, -1 * adjustedDebuffStacksInflicted(blueprint.blind), self_applied)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.ENERGIZED, -1 * adjustedDebuffStacksInflicted(blueprint.slimed), self_applied)
		adjustStatusEffectFromEnumType(STATUS_EFFECT.FOCUSED, -1 * adjustedDebuffStacksInflicted(blueprint.rage), self_applied)

		pushStatusChangesBattleMessages(blueprint.regen - adjustedDebuffStacksInflicted(blueprint.burning), blueprint.sharpened - adjustedDebuffStacksInflicted(blueprint.tranqed), blueprint.hardened - adjustedDebuffStacksInflicted(blueprint.acid), blueprint.keen - adjustedDebuffStacksInflicted(blueprint.blind), blueprint.energized - adjustedDebuffStacksInflicted(blueprint.slimed), blueprint.focused - adjustedDebuffStacksInflicted(blueprint.rage))



func receiveRecombination(self_applied: bool) -> void:
	var buffs: Array[STATUS_EFFECT] = []
	var debuff: STATUS_EFFECT
	var neutralize: STATUS_EFFECT
	
	# All effects except regen/burning eligible
	var candidate_effects: Array[STATUS_EFFECT] = [STATUS_EFFECT.SHARPENED, STATUS_EFFECT.HARDENED, STATUS_EFFECT.KEEN, STATUS_EFFECT.ENERGIZED, STATUS_EFFECT.FOCUSED]
	
	# Pop one effect from the candidates array. This is the debuff
	debuff = candidate_effects.pop_at(randi() % candidate_effects.size() - 1)
	# Pop one additional effect from the candidates array to set to 0. What remains are the ones that will be buffed
	neutralize = candidate_effects.pop_at(randi() % candidate_effects.size() - 1)
	buffs = candidate_effects
	
	for effect in buffs:
		setStatusEffectFromEnumType(effect, RECOMBINE_STACKS, self_applied)
	setStatusEffectFromEnumType(debuff, RECOMBINE_STACKS * -1, self_applied)
	setStatusEffectFromEnumType(neutralize, 0, self_applied)


func pushBattleMessage(update: String) -> void:
	battle_messages.append(update)


func retrieveBattleMessages() -> Array[String]:
	var result: Array[String] = []
	while not battle_messages.is_empty():
		result.append(battle_messages.pop_front())
	return result


# Returns a list of all combat action blueprints installed
func allCombatActionBlueprints() -> Array:
	var result = []
	for blueprint in morphose.blueprints_attack:
		result.append(blueprint)
	for blueprint in morphose.blueprints_support:
		result.append(blueprint)
	return result


# Possible actions are any it has the TP for
func getPossibleBlueprintActions() -> Array:

	var result: Array = []

	for blueprint in allCombatActionBlueprints():
		if canUseBlueprint(blueprint):
			result.append(blueprint)
		else:
			if blueprint.hasPredecessors():
				for pred in blueprint.predecessors:
					if canUseBlueprint(pred):
						result.append(pred)
						break	# We only want the strongest useable predecessor blueprint

	return result


func getPossibleAttackActions() -> Array[BlueprintAttack]:
	var result: Array[BlueprintAttack] = []

	for blueprint in morphose.blueprints_attack:
		if blueprint.getTechPointCost() <= tech_points:
			result.append(blueprint)
		else:
			if blueprint.hasPredecessors():
				for pred in blueprint.predecessors:
					if pred.getTechPointCost() <= tech_points:
						result.append(pred)
						break

	return result


func canAttack():
	return not getPossibleAttackActions().is_empty()


func hasAttackBlueprints():
	return not morphose.blueprints_attack.is_empty()


func getPossibleSupportActions() -> Array[BlueprintSupport]:
	var result: Array[BlueprintSupport] = []

	for blueprint in morphose.blueprints_support:
		if blueprint.getTechPointCost() <= tech_points:
			result.append(blueprint)
		else:
			if blueprint.hasPredecessors():
				for pred in blueprint.predecessors:
					if pred.getTechPointCost() <= tech_points:
						result.append(pred)
						break

	return result


func canSupport() -> bool:
	return not getPossibleSupportActions().is_empty()


func hasSupportBlueprints() -> bool:
	return not morphose.blueprints_support.is_empty()


func wait() -> void:
	regenTP()
	pushBattleMessage(getName() + " focuses...\n...regains " + str(getStatusEffectAdjustedTPRegen()) + " Tech Points.")


func run() -> void:
	pushBattleMessage("The party attempts to flee.")


func isValidSupportTarget(blueprint: BlueprintSupport) -> bool:
	return (isDefeated() and blueprint.can_revive) or (not isDefeated() and not blueprint.can_revive)


# Returns sum of value of character's buffs, positive and negative
func sumOfBuffs() -> int:
	return regen_stacks + sharpened_stacks + hardened_stacks + keen_stacks + energized_stacks + focused_stacks


# Returns value of biggest debuff
func biggestBuff() -> int:
	var result: int = 0
	for stacks in [regen_stacks, sharpened_stacks, hardened_stacks, keen_stacks, energized_stacks, focused_stacks]:
		if stacks > result:
			result = stacks
	return result


# Returns value of biggest debuff
func biggestDebuff() -> int:
	var result: int = 0
	for stacks in [regen_stacks, sharpened_stacks, hardened_stacks, keen_stacks, energized_stacks, focused_stacks]:
		if stacks < result:
			result = stacks
	return abs(result)


# Returns true if blueprint added to list, false if insufficient TP
func addBlueprintToActionListIfUseable(list: Array, blueprint_name: String, blueprint_tier: int = 0) -> bool:
	var blueprint = getBlueprint(blueprint_name, blueprint_tier)
	if canUseBlueprint(blueprint):
		list.append(blueprint)
		return true
	return false


# Returns true if sufficient TP to use blueprint, false otherwise
func canUseBlueprint(blueprint) -> bool:
	return blueprint.getTechPointCost() <= tech_points


func getBlueprint(bp_name: String, bp_tier = 0):
	return Blueprint.getBlueprintFromList(morphose.allBlueprints(), bp_name, bp_tier)
