class_name DialogBox
extends Panel

@export var num_rows: int = 4
@export var expands_down: bool = true
@export var expand_programmatically = true
const ROW_HEIGHT_PX = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if expand_programmatically:
		setSizeAndPosition()


func displayText(text: String) -> void:
	$Label.text = text
	setLabelSize()


func setSizeAndPosition() -> void:
	var size_y_old: float = size.y
	size.y = ROW_HEIGHT_PX * (num_rows + 2)		# 2 additional rows for box edges
	if not expands_down:
		position.y -= (size.y - size_y_old)
	setLabelSize()


# Returns true if the dialog box extends down past the bottom of the screen
func extendsPastScreenBottom() -> bool:
	return global_position.y + size.y > GlobalProgramData.VIEWPORT_RESOLUTION.y


func setLabelSize() -> void:
	if has_node("Label"):
		if $Label != null:
			$Label.size.x = size.x - ($Label.position.x * 2)
