extends DialogBox


const BLUEPRINTS_PER_PAGE: int = 16
const MAX_BIO_ENERGY_COST_DIGITS: int = 4

const INITIAL_BLUEPRINT_BUTTON_POSITION = Vector2(8, 8)
const NEXT_BLUEPRINT_Y_OFFSET = 8

var current_page: int = 0

var blueprint_list: Array = []

var assigned_party_member: PartyMember

@export var checks_tp_cost: bool
@export var SelectBlueprintButton: PackedScene
signal blueprint_selected


func assignBuyableBlueprintList(blueprint_list_in: Array, party_member: PartyMember):
	blueprint_list = []
	for blueprint in blueprint_list_in:
		if not blueprint.isInList(blueprint_list) and not blueprint.isInList(party_member.getAllBlueprints()) and party_member.blueprintIsCompatible(blueprint):
			blueprint_list.append(blueprint)
	blueprint_list.sort_custom(Blueprint.sortBlueprintsAscending)
	current_page = 0
	assigned_party_member = party_member
	populateButtonList()


func assignPartyMemberBlueprintList(party_member: PartyMember):
	blueprint_list = []
	for blueprint in party_member.getAllBlueprints():
		if not blueprint.isInList(blueprint_list):
			blueprint_list.append(blueprint)
	blueprint_list.sort_custom(Blueprint.sortBlueprintsAscending)
	current_page = 0
	assigned_party_member = party_member
	populateButtonList()


func prevPage() -> void:
	current_page -= 1
	populateButtonList()


func nextPage() -> void:
	current_page += 1
	populateButtonList()


# actor_tp optional parameter checks whether an actor has the bio energy to install blueprint, and if not, disables
# Default value of 0 will never disable a blueprint
func populateButtonList() -> void:
	
	# First clear any existing buttons
	for node in get_children():
		if node is SelectBlueprintButton:
			node.call_deferred("queue_free")
	
	if isOnFirstPage():
		$ButtonPrevList.hide()
	else:
		$ButtonPrevList.show()
	if isOnLastPage():
		$ButtonNextList.hide()
	else:
		$ButtonNextList.show()
	
	var start_button_index: int =  BLUEPRINTS_PER_PAGE * current_page
	var end_button_index: int = mini(start_button_index + BLUEPRINTS_PER_PAGE, blueprint_list.size())

	for i in range(start_button_index, end_button_index):
		var select_blueprint_button = SelectBlueprintButton.instantiate()
		add_child(select_blueprint_button)
		select_blueprint_button.blueprint = blueprint_list[i]
		select_blueprint_button.position = INITIAL_BLUEPRINT_BUTTON_POSITION + Vector2(0, NEXT_BLUEPRINT_Y_OFFSET * (i - BLUEPRINTS_PER_PAGE * current_page))
		if checks_tp_cost:
			select_blueprint_button.disabled = blueprint_list[i].getBioEnergyCost() > assigned_party_member.bio_energy
		select_blueprint_button.choose_blueprint.connect(blueprintSelected)
		select_blueprint_button.text = blueprintButtonText(blueprint_list[i])


func numPages() -> int:
	return maxi(1, ceili(float(blueprint_list.size()) / BLUEPRINTS_PER_PAGE))


func isOnFirstPage() -> bool:
	return current_page == 0


func isOnLastPage() -> bool:
	return current_page == numPages() - 1		# Pages are 0-indexed, so subtract 1


func blueprintSelected(blueprint):
	emit_signal("blueprint_selected", blueprint)


func blueprintButtonText(blueprint) -> String:
	return " " + blueprint.getMenuDisplayName() + " " + str(blueprint.getBioEnergyCost()).lpad(MAX_BIO_ENERGY_COST_DIGITS) + "M"
