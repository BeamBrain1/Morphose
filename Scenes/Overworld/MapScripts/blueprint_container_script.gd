class_name BlueprintContainerScript
extends MapScript


@export var blueprint_name: String
@export var tier: int = 1


func initialize(blueprint_name_in: String, tier_in: int = tier) -> void:
	blueprint_name = blueprint_name_in
	tier = tier_in


func body() -> void:
	await giveBlueprint(blueprint_name, tier)
	await displayDialog(SpokenDialogBox.SYSTEM_DIALOG, "Copied genetic blueprint for " + Blueprint.getDialogDisplayNameFromParameters(blueprint_name, tier) + ".")
