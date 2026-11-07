extends Node2D

const TRANSITION_STEP_TIME: float = 0.1


func transitionClose() -> void:
	while not transitionCloseFinished():
		contractBorders()
		await get_tree().create_timer(TRANSITION_STEP_TIME).timeout


func transitionOpen() -> void:
	while not transitionOpenFinished():
		openBorders()
		await get_tree().create_timer(TRANSITION_STEP_TIME).timeout


func transitionCloseFinished() -> bool:
	return $Top.size.y >= $Bottom.position.y or $Left.size.x >= $Right.position


func transitionOpenFinished() -> bool:
	return $Top.size.y == 0 or $Left.size.x == 0


func contractBorders() -> void:
	$Top.size.y += OverworldMap.TILE_SIZE
	$Left.size.x += OverworldMap.TILE_SIZE
	$Bottom.size.y += OverworldMap.TILE_SIZE
	$Bottom.position.y -= OverworldMap.TILE_SIZE
	$Right.size.x += OverworldMap.TILE_SIZE
	$Right.position.x -= OverworldMap.TILE_SIZE


func openBorders() -> void:
	$Top.size.y -= OverworldMap.TILE_SIZE
	$Left.size.x -= OverworldMap.TILE_SIZE
	$Bottom.size.y -= OverworldMap.TILE_SIZE
	$Bottom.position.y += OverworldMap.TILE_SIZE
	$Right.size.x -= OverworldMap.TILE_SIZE
	$Right.position.x += OverworldMap.TILE_SIZE
