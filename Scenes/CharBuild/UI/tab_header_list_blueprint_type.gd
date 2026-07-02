extends "res://Scenes/Global/UI/tab_header_list.gd"



func setTypesSelectable(attack: Array[BlueprintAttack], support: Array[BlueprintSupport], passive: Array[BlueprintPassive]) -> void:
	return
	#$TabHeaderAttack.disabled = attack.is_empty()
	#$TabHeaderSupport.disabled = support.is_empty()
	#$TabHeaderPassive.disabled = passive.is_empty()
