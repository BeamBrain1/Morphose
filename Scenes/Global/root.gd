class_name Root
extends Node2D

var active_controller

const CONTROLLER_DIRECTORY_AND_PREFIX = "res://Scenes/Controllers/Controller"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScriptHandler.assignRoot(self)
	#get_tree().root.content_scale_size = Vector2(960, 720)
	randomize()
	loadStartingPartyMembers()
	ActiveSaveData.party.setLocationAndDirection(OverworldPosition.new("FactoryPens", Vector2(0, 0)))
	toOverworld()


func setActiveController(controller: String) -> void:
	if active_controller != null:
		active_controller.call_deferred("queue_free")
	active_controller = load(CONTROLLER_DIRECTORY_AND_PREFIX + controller + ".tscn").instantiate()
	active_controller.root = self
	add_child(active_controller)
	active_controller.switch_to_battle_controller.connect(toBattleController)
	active_controller.switch_to_char_build_controller.connect(toCharacterBuildScreen)
	active_controller.switch_to_overworld_controller.connect(toOverworld)
	if $ScriptHandler.hasCurrentScript():	# If actively running a script, save it between scenes
		$ScriptHandler.storeCurrentScriptAsPersistent()


# won_previous: Did we win a previous battle? Used to determine whether to add a new party member
#	(a party member only gets added the first time we prep for a specific battle number
func toCharacterBuildScreen(at_modification_station: bool = true) -> void:
	setActiveController("BuildCharacter")
	active_controller.configureAtModificationStation(at_modification_station)


func toBattleController(enemy_list: Array) -> void:
	setActiveController("Battle")
	if $ScriptHandler.hasCurrentScript():
		$ScriptHandler.battle_result.connect($ScriptHandler.setBattleResult)
	active_controller.initializeBattle(enemy_list)


func toOverworld() -> void:
	setActiveController("Overworld")
	active_controller.execute_script.connect($ScriptHandler.assignAndExecuteScript)
	active_controller.on_map_load.connect($ScriptHandler.onMapLoad)
	active_controller.loadSavedPartyLocation()


func loadStartingPartyMembers() -> void:
	ActiveSaveData.party.buildStartingParty()


func giveAllBlueprints() -> void:
	for blueprint in GlobalProgramData.all_blueprints:
		if blueprint is BlueprintAttack:
			ActiveSaveData.party.collectBlueprint(blueprint)
		elif blueprint is BlueprintSupport:
			ActiveSaveData.party.collectBlueprint(blueprint)
		elif blueprint is BlueprintPassive:
			ActiveSaveData.party.collectBlueprint(blueprint)


# Returns the current active controller if it is a ControllerOverworld
# Returns null otherwise
func getControllerOverworldOrNull() -> ControllerOverworld:
	if active_controller is ControllerOverworld:
		return active_controller
	return null
