extends Node2D

var current_map: OverworldMap

const ENCOUNTER_RATE: int = 10
const ENCOUNTER_THRESHOLD: int = 100

signal encounter_activated


func assignMap(map_in: OverworldMap) -> void:
	current_map = map_in
	current_map.party_stepped.connect(partyStepped)


func partyStepped(scripted_step: bool = false) -> void:
	if not scripted_step and current_map.partyEncounterZone() != null:
		ActiveSaveData.overworld_danger_level += 1 + randi() % ENCOUNTER_RATE
		if ActiveSaveData.overworld_danger_level >= ENCOUNTER_THRESHOLD:
			doEncounter(current_map.partyEncounterZone())


func doEncounter(zone: EncounterZone) -> void:
	emit_signal("encounter_activated", zone.getRandomEncounter())
