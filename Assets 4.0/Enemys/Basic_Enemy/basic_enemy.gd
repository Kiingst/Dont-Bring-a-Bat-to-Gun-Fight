extends CharacterBody2D
var alerted = false
var health = 0
var alive = true
var MOVE_SPEED : int = 50
var going_left = randi() % 2 == 0
var is_velocity_zero = false
var Can_Switch_Direction = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#3 states attacking wonder and Death


func _physics_process(delta):
	#adding to group
	add_to_group("Enemys")
	#check if alive
	if alive == true:
		control(delta)
	
	

func control(delta):
	velocity.y += gravity * delta
	
	#Checks if velocity is 0 
	if velocity.x == 0:
		is_velocity_zero = true
	else:
		is_velocity_zero = false
	
	if alive == false:
		Death()
	
	#Switch between alert and wonder mode
	if alerted == true:
		attack_mode(delta)
	else:
		wonder_Mode(delta)
		
	move_and_slide()


func attack_mode(delta):
	pass
	# will display a exlamation point when entering attack mode
	#will run at the player untill it collides with it.
	# dies on impact with player
	

func wonder_Mode(delta):
	#state where enemy wonders around untill alerted by player
	
	if going_left == true:
		velocity.x = MOVE_SPEED
	else:
		velocity.x = -MOVE_SPEED
	
	#switching direction when hit by a wall timer for a bug i found
	if Can_Switch_Direction == true:
		if is_velocity_zero == true:
			print("switching")
			if going_left == true:
				going_left = false
				Can_Switch_Direction = false
				$Direction_Switch_Cooldown.start()
			else:
				going_left = true
				Can_Switch_Direction = false
				$Direction_Switch_Cooldown.start()
	
	

#Kills enemy
func Death():
	queue_free()

#taking damage
func take_damage(damage):
	if damage != null:
		#animation_mode.travel("damage_animation")
		health -= damage
		$HealthBar.visible = true


func _on_direction_switch_cooldown_timeout():
	Can_Switch_Direction = true
