extends Node2D

const TRANSITION_STEP_TIME: float = 0.1
const CLOSE_TO_OPEN_DELAY_TIME: float = 0.5


func transitionClose() -> void:
	while not transitionCloseFinished():
		await contractBordersStep()
	await get_tree().create_timer(CLOSE_TO_OPEN_DELAY_TIME / 2).timeout		# Split delay between close and open


func transitionOpen() -> void:
	await get_tree().create_timer(CLOSE_TO_OPEN_DELAY_TIME / 2).timeout
	while not transitionOpenFinished():
		await openBordersStep()
	call_deferred("queue_free")


func transitionCloseFinished() -> bool:
	return $Top.size.y >= $Bottom.position.y or $Left.size.x >= $Right.position.x


func transitionOpenFinished() -> bool:
	return $Top.size.y == 0 or $Left.size.x == 0


func contractBordersStep() -> void:
	$Top.size.y += OverworldMap.TILE_SIZE
	$Left.size.x += OverworldMap.TILE_SIZE
	$Bottom.size.y += OverworldMap.TILE_SIZE
	$Bottom.position.y -= OverworldMap.TILE_SIZE
	$Right.size.x += OverworldMap.TILE_SIZE
	$Right.position.x -= OverworldMap.TILE_SIZE
	$AudioTransitionStep.play()
	await get_tree().create_timer(TRANSITION_STEP_TIME).timeout


func openBordersStep() -> void:
	$Top.size.y -= OverworldMap.TILE_SIZE
	$Left.size.x -= OverworldMap.TILE_SIZE
	$Bottom.size.y -= OverworldMap.TILE_SIZE
	$Bottom.position.y += OverworldMap.TILE_SIZE
	$Right.size.x -= OverworldMap.TILE_SIZE
	$Right.position.x += OverworldMap.TILE_SIZE
	$AudioTransitionStep.play()
	await get_tree().create_timer(TRANSITION_STEP_TIME).timeout
