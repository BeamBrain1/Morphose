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
	for bp in party_member.getAllBlueprints():		# Add any blueprints party member is carrying to those collected
		collectBlueprint(bp)


func collectBlueprint(blueprint) -> void:
	
	# Ensure blueprint is not already present in collected blueprint list. If it is, don't add it
	for bp in allCollectedBlueprints():
		if blueprint.equals(bp):
			return
	
	if blueprint is BlueprintAttack:
		found_blueprints_attack.append(blueprint)
	elif blueprint is BlueprintSupport:
		found_blueprints_support.append(blueprint)
	elif blueprint is BlueprintPassive:
		found_blueprints_passive.append(blueprint)


func allCollectedBlueprints() -> Array:
	var result = []
	for list in [found_blueprints_attack, found_blueprints_support, found_blueprints_passive]:
		for blueprint in list:
			result.append(blueprint)
	return result


# Award Muta to all current party members
func awardMuta(muta: int) -> void:
	for member in members:
		member.giveBioEnergy(muta)


func setLocationAndDirection(location_in: OverworldPosition, direction: GlobalProgramData.DIRECTION = GlobalProgramData.DIRECTION.DOWN):
	location = location_in
	facing_direction = direction


func getCurrentMap() -> String:
	return location.map_name


func getCurrentGridPosition() -> Vector2:
	return location.grid_position
