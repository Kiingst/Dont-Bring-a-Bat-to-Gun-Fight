extends Node
func eval():
	var array = get_tree().get_nodes_in_group('Player') 
	var player = array.pick_random() 
	player.Auto_Pickup = true