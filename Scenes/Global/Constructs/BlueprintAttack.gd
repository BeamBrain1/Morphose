class_name BlueprintAttack extends Blueprint

var base_damage: int = 0
var damageless: bool = false	# If true, attack does not inflict direct damage
var num_hits: int = 1			# How many times attack hits individual target

var accuracy: int = 0			# % Modifier to accuracy calculations
var crit_rate: int = 0			# % Modifier to crit chance calculations
var fixed_damage: bool = false	# Ignores all user/target stats for damage and hit/crit chance
var always_hit: bool = false	# If true, attack always hits but can never crit

var burning: int = 0			# num Burning stacks attack inflicts per hit
var tranqed: int = 0			# num Tranqed stacks attack inflicts per hit
var acid: int = 0				# num Acid stacks attack inflicts per hit
var blind: int = 0				# num Blind stacks attack inflicts per hit
var slimed: int = 0				# num Slimed stacks attack inflicts per hit
var rage: int = 0				# num Rage stacks attack inflicts per hit


func isStatusEffectBlueprint() -> bool:
	return damageless
