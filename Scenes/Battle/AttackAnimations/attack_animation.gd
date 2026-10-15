class_name AttackAnimation
extends AnimatedSprite2D

signal finished_playing

var sound_array: Array[AttackSound] = []
var active_sound: AttackSound


func _ready() -> void:
	for node in get_children():
		if node is AttackSound:
			sound_array.append(node)
			node.finished.connect(onSoundFinished)


# Don't show visuals for enemy attacks - hide the animation
func start(enemy_attack: bool) -> void:
	play()
	if enemy_attack:
		hide()
	for sound in sound_array:
		if 0 in sound.play_frames:
			sound.play()
			active_sound = sound
			return


func _on_animation_finished() -> void:
	hide()
	if soundPlaying():
		await active_sound.finished
	endAnimation()


func _on_frame_changed() -> void:
	for sound in sound_array:
		if frame in sound.play_frames:
			sound.play()
			active_sound = sound
			return


func visualPlaying() -> bool:
	return visible


func soundPlaying() -> bool:
	return active_sound != null


func onSoundFinished() -> void:
	active_sound = null


func endAnimation() -> void:
	emit_signal("finished_playing")
	call_deferred("queue_free")
