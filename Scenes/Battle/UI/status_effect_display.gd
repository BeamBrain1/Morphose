extends Node2D

const ICON_SIZE: int = 8
const COLOR_GOOD: Color = Color(0, 0.6666, 0, 1)
const COLOR_BAD: Color = Color(1, 0, 0, 1)

enum STATUS_EFFECT {REGEN, SHARPENED, HARDENED, KEEN, ENERGIZED, FOCUSED}

@export var display_effect: STATUS_EFFECT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	if display_effect == STATUS_EFFECT.REGEN:
		$Icon.region_rect.position.x = ICON_SIZE * 0
	elif display_effect == STATUS_EFFECT.FOCUSED:
		$Icon.region_rect.position.x = ICON_SIZE * 1
	elif display_effect == STATUS_EFFECT.SHARPENED:
		$Icon.region_rect.position.x = ICON_SIZE * 2
	elif display_effect == STATUS_EFFECT.HARDENED:
		$Icon.region_rect.position.x = ICON_SIZE * 3
	elif display_effect == STATUS_EFFECT.KEEN:
		$Icon.region_rect.position.x = ICON_SIZE * 4
	elif display_effect == STATUS_EFFECT.ENERGIZED:
		$Icon.region_rect.position.x = ICON_SIZE * 5


func updateDisplay(stacks: int):
	if stacks == 0:
		hide()
	else:
		show()
		if stacks > 0:
			$Count.text = "+" + str(stacks)
			modulate = COLOR_GOOD
		else:
			$Count.text = str(stacks)
			modulate = COLOR_BAD
