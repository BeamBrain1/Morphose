class_name BlueprintContainer
extends ActiveMapObject

@export var blueprint_name: String
@export var blueprint_tier: int

var overworld_ui: OverworldUI

signal opened

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	map_script.initialize(blueprint_name, blueprint_tier)
	if hasBeenOpened():
		preopen()


func interactedWith() -> void:
	if not hasBeenOpened():
		play("opened")
		super()					# Only execute the attached script if we haven't already opened this container


func preopen() -> void:
	play("opened")


# A container is marked as opened if the party already has its blueprint
func hasBeenOpened() -> bool:
	var check_blueprint = Blueprint.getBlueprintFromGlobalList(blueprint_name, blueprint_tier)
	for bp in ActiveSaveData.allCollectedBlueprints():
		if bp.equals(check_blueprint):
			return true
	return false
