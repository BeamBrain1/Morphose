extends Node2D

signal on_stat_adjust

var at_mod_station: bool = true

func _ready() -> void:
	for node in $DialogCharacterStats.get_children():
		if node is StatModWindow:
			node.update_bio_energy.connect(onStatAdjust)


func loadPartyMember(party_member: PartyMember) -> void:
	for node in $DialogCharacterStats.get_children():
		if node is StatModWindow:
			node.assignPartyMember(party_member, at_mod_station)
	updateStatDisplays()


func assignAtModStationValue(at_mod_station_in: bool) -> void:
	at_mod_station = at_mod_station_in


func onStatAdjust() -> void:
	updateStatDisplays()
	emit_signal("on_stat_adjust")


func updateStatDisplays() -> void:
	for node in $DialogCharacterStats.get_children():
		if node is StatModWindow:
			node.updateDisplay()
