class_name PartyCombatant
extends Combatant

const RUN_POINT_MULTIPLIER: int = 3

func _init(morphose_in):
	morphose = morphose_in
	initializeHP()
	initializeTP()


# Escape points contribute to success in fleeing a battle
func escapePoints() -> int:
	if isDefeated():
		return 0
	else:
		return getStatusEffectAdjustedSpeed() * RUN_POINT_MULTIPLIER
