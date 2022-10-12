extends KinematicBody2D
var MOVE_SPEED = 300
var roll_speed = 400
export (int) var health
var roll_On_cooldown = false
signal take_damage
var alive = true
export (int) var Length_from_player



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Player_Control(delta):
	#Movement logic
	var move_vec = Vector2()
	var roll_speed2 = 1
	if Input.is_action_pressed("Move_Up"):
		move_vec.y -= 1
	if Input.is_action_pressed("Move_Down"):
		move_vec.y += 1
	if Input.is_action_pressed("Move_Left"):
		move_vec.x -= 1
	if Input.is_action_pressed("Move_Right"):
		move_vec.x += 1
	if Input.is_action_pressed("Swing"):
		#$Player_Weapon/AnimationPlayer.play("Swing")
		pass
		
	if Input.is_action_just_pressed("Roll"):
		if roll_On_cooldown == false:
			MOVE_SPEED += roll_speed 
			$Roll.start()
			roll_On_cooldown = true
			$Roll/Cooldown.start()
	
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	var look_vec = get_global_mouse_position() - global_position
	#$Player_Weapon/Player_Weapon.offset.x = Length_from_player
	#$Player_Weapon/Player_Weapon/Hit_Area.position.x = Length_from_player
	#$Player_Weapon/Player_Weapon/StaticBody2D.position.x = Length_from_player
	#$Player_Weapon.global_rotation = atan2(look_vec.y, look_vec.x)


func _physics_process(delta):
	if alive == false:
		return
	Player_Control(delta)


func _on_Roll_timeout():
	#Stops Roll & restes move speed
	MOVE_SPEED = 300


func _on_Cooldown_timeout():
	#Roll taken off cooldown
	roll_On_cooldown = false
	print(roll_On_cooldown)
