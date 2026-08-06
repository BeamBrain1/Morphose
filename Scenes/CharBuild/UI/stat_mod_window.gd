class_name StatModWindow
extends Node2D

@export var assigned_stat: GlobalProgramData.COMBAT_STAT

var party_member: PartyMember

signal update_bio_energy

var stat_name_map: Dictionary = {
	GlobalProgramData.COMBAT_STAT.HP: "Hit Points",
	GlobalProgramData.COMBAT_STAT.TECH_POINTS: "Tech Points",
	GlobalProgramData.COMBAT_STAT.ATTACK: "Attack",
	GlobalProgramData.COMBAT_STAT.DEFENSE: "Defense",
	GlobalProgramData.COMBAT_STAT.SPEED: "Speed",
	GlobalProgramData.COMBAT_STAT.SENSES: "Senses"
}


func _ready():
	$Name.text = stat_name_map[assigned_stat].to_upper()


func assignPartyMember(party_member_in: PartyMember) -> void:
	party_member = party_member_in
	updateDisplay()


func updateDisplay() -> void:
	setEnabledButtons()
	setStatDisplay()
	setFavoredStatIndicator()


func setStatDisplay() -> void:
	if assigned_stat == GlobalProgramData.COMBAT_STAT.HP:
		$Value.text = str(party_member.hp)
	elif assigned_stat == GlobalProgramData.COMBAT_STAT.TECH_POINTS:
		$Value.text = str(party_member.tech_points)
	elif assigned_stat == GlobalProgramData.COMBAT_STAT.ATTACK:
		$Value.text = str(party_member.attack)
	elif assigned_stat == GlobalProgramData.COMBAT_STAT.DEFENSE:
		$Value.text = str(party_member.defense)
	elif assigned_stat == GlobalProgramData.COMBAT_STAT.SPEED:
		$Value.text = str(party_member.speed)
	elif assigned_stat == GlobalProgramData.COMBAT_STAT.SENSES:
		$Value.text = str(party_member.senses)


func setEnabledButtons() -> void:
	$ButtonMinus100.disabled = not party_member.canDecreaseStat(assigned_stat)
	$ButtonMinus10.disabled = not party_member.canDecreaseStat(assigned_stat)
	$ButtonMinus1.disabled = not party_member.canDecreaseStat(assigned_stat)
	$ButtonPlus1.disabled = not party_member.canIncreaseStat(assigned_stat)
	$ButtonPlus10.disabled = not party_member.canIncreaseStat(assigned_stat)
	$ButtonPlus100.disabled = not party_member.canIncreaseStat(assigned_stat)


func setFavoredStatIndicator() -> void:
	if assigned_stat in party_member.discounted_stats:
		$FavoredStatMarker.show()
	else:
		$FavoredStatMarker.hide()


func _on_button_minus_10_pressed() -> void:
	for i in range(10):
		if party_member.canDecreaseStat(assigned_stat):
			party_member.statMinusOne(assigned_stat)
		else:
			break
	emit_signal("update_bio_energy")


func _on_button_minus_1_pressed() -> void:
	
	if party_member.canDecreaseStat(assigned_stat):
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


func _on_button_minus_100_pressed() -> void:
	for i in range(100):
		if party_member.canDecreaseStat(assigned_stat):
			party_member.statMinusOne(assigned_stat)
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
