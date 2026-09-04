class_name StatModWindow
extends Node2D

@export var assigned_stat: GlobalProgramData.COMBAT_STAT

var party_member: PartyMember
var at_modification_station: bool = true

signal update_bio_energy

var stat_name_map: Dictionary = {
	GlobalProgramData.COMBAT_STAT.HP: "Hit Pts",
	GlobalProgramData.COMBAT_STAT.TECH_POINTS: "Tech Pts",
	GlobalProgramData.COMBAT_STAT.ATTACK: "Attack",
	GlobalProgramData.COMBAT_STAT.DEFENSE: "Defense",
	GlobalProgramData.COMBAT_STAT.SPEED: "Speed",
	GlobalProgramData.COMBAT_STAT.SENSES: "Senses"
}


func _ready():
	$Name.text = stat_name_map[assigned_stat].to_upper()


func assignPartyMember(party_member_in: PartyMember, at_mod_station_in: bool = true) -> void:
	at_modification_station = at_mod_station_in
	party_member = party_member_in
	updateDisplay()


func updateDisplay() -> void:
	setEnabledButtons()
	setStatDisplay()
	setFavoredStatIndicator()


func setStatDisplay() -> void:
	$Value.text = str(party_member.getRawStatFromEnumType(assigned_stat)) + " "
	if party_member.getRawStatFromEnumType(assigned_stat) != party_member.getStatFromEnumType(assigned_stat):
		$Value.text += "\n(" + str(party_member.getStatFromEnumType(assigned_stat)) + ")"


func setEnabledButtons() -> void:
	$ButtonMinus100.disabled = not canDecreaseStat()
	$ButtonMinus10.disabled = not canDecreaseStat()
	$ButtonMinus1.disabled = not canDecreaseStat()
	$ButtonPlus1.disabled = not party_member.canIncreaseStat(assigned_stat)
	$ButtonPlus10.disabled = not party_member.canIncreaseStat(assigned_stat)
	$ButtonPlus100.disabled = not party_member.canIncreaseStat(assigned_stat)


# Is party member stat at the value it was when character builder was opened?
func partyMemberStatAtInitial() -> bool:
	return party_member.getRawStatFromEnumType(assigned_stat) == ActiveSaveData.getPartyMemberByName(party_member.name).getRawStatFromEnumType(assigned_stat)


func canDecreaseStat() -> bool:
	if at_modification_station:
		return party_member.canDecreaseStat(assigned_stat)
	else:
		return not partyMemberStatAtInitial()


func setFavoredStatIndicator() -> void:
	if assigned_stat in party_member.discounted_stats:
		$FavoredStatMarker.show()
	else:
		$FavoredStatMarker.hide()


func _on_button_minus_100_pressed() -> void:
	for i in range(100):
		if canDecreaseStat():
			party_member.statMinusOne(assigned_stat)
		else:
			break
	emit_signal("update_bio_energy")


func _on_button_minus_10_pressed() -> void:
	for i in range(10):
		if canDecreaseStat():
			party_member.statMinusOne(assigned_stat)
		else:
			break
	emit_signal("update_bio_energy")


func _on_button_minus_1_pressed() -> void:
	if canDecreaseStat():
		party_member.statMinusOne(assigned_stat)
	emit_signal("update_bio_energy")


func _on_button_plus_1_pressed() -> void:
	if party_member.canIncreaseStat(assigned_stat):
		party_member.statPlusOne(assigned_stat)
	emit_signal("update_bio_energy")


func _on_button_plus_10_pressed() -> void:
	for i in range(10):
		if party_member.canIncreaseStat(assigned_stat):
			party_member.statPlusOne(assigned_stat)
		else:
			break
	emit_signal("update_bio_energy")


func _on_button_plus_100_pressed() -> void:
	for i in range(100):
		if party_member.canIncreaseStat(assigned_stat):
			party_member.statPlusOne(assigned_stat)
		else:
			break
	emit_signal("update_bio_energy")
