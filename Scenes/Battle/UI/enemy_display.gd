class_name EnemyDisplay
extends Button

var enemy: EnemyCombatant

signal select_combatant
const HIT_FLASH_TIME: float = 0.125
const NUM_HIT_FLASHES: int = 2
const SIMULTANEOUS_EATEN_CHUNKS = 4
const EAT_STEP_INTERVAL: float = 0.125
const EAT_FINAL_DELAY: float = 0.125

@export var EatenChunk: PackedScene

const ENEMY_IMAGE_DIRECTORY = "res://Graphics/Enemies/"
const ENEMY_IMAGE_EXT = ".png"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disabled = true
	$LabelName.hide()


func assignCombatant(enemy_in: EnemyCombatant) -> void:
	enemy = enemy_in
	if hasImage():
		assignImage()
	show()
	$LabelName.text = enemy.getName().to_upper()
	if $LabelName.text.length() % 2 == 1:
		$LabelName.text += " "	# Since label centered, even number of characters necessary to align text to grid
	updateDisplay()


func enableTargetingIfEnemyAlive():
	if not enemy.isDefeated():
		disabled = false


func disableTargeting():
	disabled = true


func updateDisplay():
	if enemy.isDefeated():
		$StatusEffectDisplays.hide()
		$EnemySprite.material.set_shader_parameter("defeated", true)
		disableTargeting()
	else:
		updateStatusDisplays()


func _on_pressed() -> void:
	emit_signal("select_combatant", enemy)


func _on_mouse_entered() -> void:
	if not enemy.isDefeated():
		$LabelName.show()


func _on_mouse_exited() -> void:
	$LabelName.hide()


func updateStatusDisplays():
	$StatusEffectDisplays/Regen.updateDisplay(enemy.regen_stacks)
	$StatusEffectDisplays/Focused.updateDisplay(enemy.focused_stacks)
	$StatusEffectDisplays/Sharpened.updateDisplay(enemy.sharpened_stacks)
	$StatusEffectDisplays/Hardened.updateDisplay(enemy.hardened_stacks)
	$StatusEffectDisplays/Keen.updateDisplay(enemy.keen_stacks)
	$StatusEffectDisplays/Energized.updateDisplay(enemy.energized_stacks)


func hitFlash():
	$AudioAttackHit.play()
	for i in range(NUM_HIT_FLASHES):
		$EnemySprite.hide()
		await get_tree().create_timer(HIT_FLASH_TIME).timeout
		$EnemySprite.show()
		await get_tree().create_timer(HIT_FLASH_TIME).timeout


func hitNoDamage():
	$AudioNoDamage.play()
	await $AudioNoDamage.finished


func getEaten() -> void:
	if not enemy.morphose.gives_bio_energy:	# Don't eat inedible enemies
		return
	var eaten_chunk: ColorRect = EatenChunk.instantiate()
	var chunk_positions: Array[Vector2]		# Figure out all positions we'll need chunks to completely cover enemy sprite
	for y in range(0, $EnemySprite.texture.get_height(), int(eaten_chunk.size.y)):
		for x in range(0, $EnemySprite.texture.get_width(), int(eaten_chunk.size.x)):
			chunk_positions.append(Vector2(x, y))
	chunk_positions.shuffle()	# Randomize order in which chunks are placed
	while not chunk_positions.is_empty():
		for i in SIMULTANEOUS_EATEN_CHUNKS:		# Place simultaneous chunks, then delay
			if not chunk_positions.is_empty():	# We shouldn't run out of chunks mid-loop, but better safe than sorry
				var next_position = chunk_positions.pop_back()
				eaten_chunk = EatenChunk.instantiate()		# Place chunk at randomly selected location
				$EatenChunks.add_child(eaten_chunk)
				eaten_chunk.position = next_position
		$AudioEatStep.play()	# After eating simultaneous chunks, play audio and wait
		await get_tree().create_timer(EAT_STEP_INTERVAL).timeout
	await get_tree().create_timer(EAT_FINAL_DELAY).timeout


func getEnemyImageLocation(enemy_name: String) -> String:
	return ENEMY_IMAGE_DIRECTORY + enemy_name + ENEMY_IMAGE_EXT


func hasImage() -> bool:
	return ResourceLoader.exists(getEnemyImageLocation(enemy.getName()))


func assignImage() -> void:
	$EnemySprite.texture = load(getEnemyImageLocation(enemy.getName()))
