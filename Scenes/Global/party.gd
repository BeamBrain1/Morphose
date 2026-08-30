class_name Party
extends Node2D

var members: Array[PartyMember] = []
var location: OverworldPosition
var facing_direction: GlobalProgramData.DIRECTION

var found_blueprints_attack: Array[BlueprintAttack] = []
var found_blueprints_support: Array[BlueprintSupport] = []
var found_blueprints_passive: Array[BlueprintPassive] = []


func _init() -> void:
	members = []
	location = OverworldPosition.new()


func addPartyMember(party_member: PartyMember) -> void:
	members.append(party_member)


func addBlueprint(blueprint) -> void:
	if blueprint is BlueprintAttack:
		found_blueprints_attack.append(blueprint)
	elif blueprint is BlueprintSupport:
		found_blueprints_support.append(blueprint)
	elif blueprint is BlueprintPassive:
		found_blueprints_passive.append(blueprint)


# Award Muta to all current party members
func awardMuta(muta: int) -> void:
	for member in members:
		member.giveBioEnergy(muta)


func setLocationAndDirection(location_in: OverworldPosition, direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	location = location_in
	facing_direction = direction
