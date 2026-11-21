extends Node
var strengths = [["Water","Fire"],["Fire","Poison"],["Poison","Earth"],["Earth","Water"]]
func attackMultiplier(attack_element, element):
	if [attack_element,element] in strengths:
		return 2.0
	elif [element,attack_element] in strengths:
		return 0.5
	else:
		return 1.0


	
