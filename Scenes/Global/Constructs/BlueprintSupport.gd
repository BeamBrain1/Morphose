class_name BlueprintSupport extends Blueprint
	
var base_healing: int = 0		# How much ability heals
var can_revive: bool = false	# If true, can revive downed party members
var self_only: bool = false	# If true, can only target self
	
var regen: int = 0			# num Healing stacks ability gives per hit
var sharpened: int = 0			# num Sharpened stacks ability gives per hit
var hardened: int = 0			# num Hardened stacks ability gives per hit
var keen: int = 0				# num Keen stacks ability gives per hit
var energized: int = 0			# num Energized stacks ability gives per hit
var focused: int = 0			# num Focused stacks ability gives per hit

# For support blueprints that can heal negative status effects but not necessarily apply positive ones
var heal_burning: int = 0
var heal_tranqed: int = 0
var heal_acid: int = 0
var heal_blind: int = 0
var heal_slimed: int = 0
var heal_rage: int = 0

# For support blueprints that have adverse side effects
var burning: int = 0
var tranqed: int = 0
var acid: int = 0
var blind: int = 0
var slimed: int = 0
var rage: int = 0
