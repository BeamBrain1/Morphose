class_name PartyCombatant
extends Combatant


func _init(party_member: PartyMember):
	name = party_member.name
	hp = party_member.hp
	max_hp = hp
	tech_points = party_member.tech_points
	max_tp = tech_points
	attack = party_member.attack
	defense = party_member.defense
	senses = party_member.senses
	speed = party_member.speed
	blueprints_attack = party_member.blueprints_attack
	blueprints_support = party_member.blueprints_support
	blueprints_passive = party_member. blueprints_passive
