extends Panel

var bio_energy: int


func loadPartyMember(party_member: PartyMember):
	setMutaCount(party_member.bio_energy)


func setMutaCount(bio_energy_in: int):
	show()
	bio_energy = bio_energy_in
	$MutaCount.text = str(bio_energy_in) + "\nMUTA"
