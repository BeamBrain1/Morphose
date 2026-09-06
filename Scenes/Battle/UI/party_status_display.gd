extends Node2D

@export var PartyMemberStatusDisplay: PackedScene
var party_member_status_displays: Array

signal select_as_support_target

const FIRST_PARTY_MEMBER_DISPLAY_POSITION: Vector2 = Vector2(0, 25)
const NEXT_PARTY_MEMBER_DISPLAY_OFFSET_Y: int = 16


func assignPartyMemberStatusDisplaysFromList(party_combatants: Array[PartyCombatant]) -> void:
	for display in party_member_status_displays:
		display.call_deferred("queue_free")
	party_member_status_displays = []
	for combatant in party_combatants:
		var party_member_status_display = PartyMemberStatusDisplay.instantiate()
		party_member_status_display.assignCombatant(combatant)
		add_child(party_member_status_display)
		party_member_status_display.position = FIRST_PARTY_MEMBER_DISPLAY_POSITION + Vector2(0, party_member_status_displays.size() * NEXT_PARTY_MEMBER_DISPLAY_OFFSET_Y)
		party_member_status_displays.append(party_member_status_display)
		party_member_status_display.select_as_support_target.connect(selectAsSupportTarget)


func updatePartyMemberStatusDisplays() -> void:
	for display in party_member_status_displays:
		display.updateStatusDisplay()


func activateSupportTargetButtons(blueprint: BlueprintSupport) -> void:
	for display in party_member_status_displays:
		display.activateTargetSelection(blueprint)


func deactivateSupportTargetButtons() -> void:
	for display in party_member_status_displays:
		display.disableTargetSelection()


func selectAsSupportTarget(combatant):
	emit_signal("select_as_support_target", combatant)


func getPlayerCombatants() -> Array[PartyCombatant]:
	var result: Array[PartyCombatant] = []
	for display in party_member_status_displays:
		result.append(display.combatant)
	return result


func numberOfPartyMembers() -> int:
	return getPlayerCombatants().size()


func toggleTurnIndicators(current_actor: Combatant) -> void:
	for display in party_member_status_displays:
		display.toggleTurnIndicator(current_actor)


func getPartyRunPoints() -> int:
	var result = 0
	for combatant in getPlayerCombatants():
		result += combatant.escapePoints()
	return result
