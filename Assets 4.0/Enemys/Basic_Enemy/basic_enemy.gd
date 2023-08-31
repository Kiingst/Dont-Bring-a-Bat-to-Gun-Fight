extends CharacterBody2D

var alive = true
#3 states attacking wonder and Death


func _physics_process(delta):
	add_to_group("Enemys")
	if alive == true:
		control(delta)
	
	

func control(delta):
	pass

func attack_mode():
	pass
	# will display a exlamation point when entering attack mode
	#will run at the player untill it collides with it.
	# dies on impact with player
	

func wonder_Mode():
	pass
	#walk for a random set of time then turn around
	#will turn around if it hits a wall
	
	

func Death():
	pass
