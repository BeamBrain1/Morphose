extends Controller

var party_member_list: Array[PartyMember]
var blueprints_attack: Array[BlueprintAttack]
var blueprints_support: Array[BlueprintSupport]
var blueprints_passive: Array[BlueprintPassive]

var active_party_member: PartyMember
var active_blueprint_type: String
var active_window: String


func _ready() -> void:
	loadDataFromGlobal()


func loadDataFromGlobal() -> void:
	
	party_member_list = []
	blueprints_attack = []
	blueprints_support = []
	blueprints_passive = []
	
	for item in ActiveSaveData.party_members:
		party_member_list.append(item)

	for item in ActiveSaveData.found_blueprints_attack:
		blueprints_attack.append(item)

	for item in ActiveSaveData.found_blueprints_support:
		blueprints_support.append(item)

	for item in ActiveSaveData.found_blueprints_passive:
		blueprints_passive.append(item)
	
	$WindowBase.loadPartyMemberList(party_member_list)
	$WindowBlueprintManager.updateAvailableBlueprints(blueprints_attack, blueprints_support, blueprints_passive)


func buildWindowSelected(window: String) -> void:
	active_window = window
	if active_window.to_upper() == "BLUEPRINTS" and active_party_member != null:
		$WindowBlueprintManager.show()
		$WindowStatsAdjust.hide()
	elif active_window.to_upper() == "STATS" and active_party_member != null:
		$WindowBlueprintManager.hide()
		$WindowStatsAdjust.show()


func partyMemberTabSelected(party_member_name: String) -> void:
	var active_party_member_was_null = active_party_member == null
	active_party_member = getPartyMemberFromName(party_member_name)
	updateWindowBase()
	updateStatsDisplay()
	updateBlueprintManager()
	if active_party_member_was_null:
		$WindowBase/DialogBuildWindow.show()
	if active_blueprint_type == "":		# Ensures blueprint window does not start empty.
		$WindowBlueprintManager.chooseFirstBlueprintType()


func getPartyMemberFromName(pn_name: String) -> PartyMember:
	for party_member in party_member_list:
		if party_member.name.to_upper() == pn_name.to_upper():
			return party_member
	push_error("Party member not found: " + pn_name)
	return null


func blueprintTypeSelected(type: String) -> void:
	active_blueprint_type = type.to_upper()
	updateBlueprintManager()


func updateStatsDisplay() -> void:
	$WindowStatsAdjust.loadPartyMember(active_party_member)


func updateBlueprintManager() -> void:
	$WindowBlueprintManager.updateDisplay(active_party_member, active_blueprint_type)


func updateWindowBase() -> void:
	$WindowBase.loadPartyMember(active_party_member)


func updateAllDisplays() -> void:
	updateWindowBase()
	updateStatsDisplay()
	updateBlueprintManager()


func resetActiveCharacter() -> void:
	if active_party_member != null:
		active_party_member.liquidateBioEnergy()
		updateAllDisplays()
	else:
		push_error("Tried to reset bio-energy when no party member selected.")


func save() -> void:
	ActiveSaveData.party_members = party_member_list
	root.setActiveController("Battle")


func cancel() -> void:
	root.setActiveController("Battle")


# Skip upcoming battle
func _on_window_base_skip() -> void:
	root.skipBattle()


func _on_window_base_zenith() -> void:
	root.skipToZenith()
