extends Node2D

var active_party_member: PartyMember
var blueprints_attack: Array[BlueprintAttack]
var blueprints_support: Array[BlueprintSupport]
var blueprints_passive: Array[BlueprintPassive]
var current_blueprint_type: String

signal blueprint_type_selected
signal blueprint_lists_modified


func updateDisplay(party_member: PartyMember = active_party_member, blueprint_type: String = current_blueprint_type) -> void:
	if party_member != null and blueprint_type != null:
		active_party_member = party_member
		current_blueprint_type = blueprint_type
		var blueprint_list_to_assign: Array
		if blueprint_type == "ATTACK":
			blueprint_list_to_assign = blueprints_attack
		elif blueprint_type == "SUPPORT":
			blueprint_list_to_assign = blueprints_support
		elif blueprint_type == "PASSIVE":
			blueprint_list_to_assign = blueprints_passive

		$DialogInstalledBlueprints/Selector.assignPartyMemberBlueprintList(party_member)
		$DialogAvailableBlueprints/Selector.assignBuyableBlueprintList(blueprint_list_to_assign, party_member)
		$DialogBlueprintSlots.assignPartyMember(party_member)


func updateAvailableBlueprints(attack: Array[BlueprintAttack], support: Array[BlueprintSupport], passive: Array[BlueprintPassive]) -> void:

	blueprints_attack = attack
	blueprints_support = support
	blueprints_passive = passive
	$DialogBlueprintTypeSelect/TabHeaderList.setTypesSelectable(attack, support, passive)


func onBlueprintTypeSelected(type: String) -> void:
	emit_signal("blueprint_type_selected", type)


func chooseFirstBlueprintType() -> void:
	$DialogBlueprintTypeSelect/TabHeaderList.selectFirst()


func uninstallBlueprint(blueprint) -> void:
	active_party_member.uninstallBlueprint(blueprint)
	updateDisplay()
	emit_signal("blueprint_lists_modified")


func installBlueprint(blueprint) -> void:
	active_party_member.installBlueprint(blueprint)
	updateDisplay()
	emit_signal("blueprint_lists_modified")


func _on_dialog_blueprint_slots_slots_changed() -> void:
	updateDisplay()
	emit_signal("blueprint_lists_modified")
