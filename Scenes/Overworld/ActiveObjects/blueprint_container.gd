class_name BlueprintContainer
extends ActiveMapObject

@export var blueprint_name: String
@export var blueprint_tier: int

var blueprint: Blueprint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assignBlueprint()
	if hasBeenOpened():
		preopen()


func assignBlueprint() -> void:
	blueprint = Blueprint.getBlueprintFromGlobalList(blueprint_name, blueprint_tier)


func open() -> void:
	play("opened")


func preopen() -> void:
	play("opened")


func getBlueprint() -> Blueprint:
	return blueprint


# A container is marked as opened if the party already has its blueprint
func hasBeenOpened() -> bool:
	for bp in ActiveSaveData.allCollectedBlueprints():
		if bp.equals(blueprint):
			return true
	return false
