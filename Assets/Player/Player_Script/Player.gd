extends KinematicBody2D
var MOVE_SPEED = 300
var roll_speed = 400
export (int) var health
var roll_On_cooldown = false
signal take_damage
var alive = true
export (int) var Length_from_player
var swing = 1
var side = 1
onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
onready var Weapon_animation_tree = $Player_Weapon/AnimationTree
onready var Weapon_animation_mode = Weapon_animation_tree.get("parameters/playback")
onready var swing_left = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Swing_Left")


var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
		pass
	if Input.is_action_just_pressed("Roll"):
		if roll_On_cooldown == false:
			MOVE_SPEED += roll_speed 
			$Roll.start()
			roll_On_cooldown = true
			$Roll/Cooldown.start()
	move_vec = move_vec.normalized()
	var animation_vec = Vector2()
	
	
	print($Cross_Hair/Position2D.position)
	
	
	var look_vec = get_global_mouse_position() - global_position
	var look_ang = rad2deg(atan2(look_vec.y, look_vec.x))
	$Cross_Hair.global_rotation = atan2(look_vec.y, look_vec.x)
	
	if look_ang > -45 && look_ang <= 0:
		side = 1
	elif look_ang >= 0 && look_ang <= 45:
		side = 1
	elif look_ang > 45 && look_ang <= 135:
		side = 2
	elif look_ang > 135 && look_ang <= 180:
		side = 3
	elif look_ang >= -180 && look_ang <= -135:
		side = 3
	elif look_ang > -135 && look_ang <= -45:
		side = 4
	
	match side:
		1:
			#right
			animation_vec = move_vec
			$Player_Weapon/Player_Weapon.position = Vector2(-1 * Length_from_player, 0)
			if move_vec.x == -1:
				animation_vec.x = move_vec.x * -1
			else:
				animation_vec = move_vec
		2:
			#up
			#animation_vec = move_vec
			#$Player_Weapon/Player_Weapon.position = Vector2(0, -1 * Length_from_player)
			pass
		3:
			#left
			if move_vec.x == 1:
				animation_vec.x = move_vec.x * -1
			else:
				animation_vec = move_vec
			$Player_Weapon/Player_Weapon.position = Vector2(Length_from_player, 0)
		4:
			##down
			#animation_vec = move_vec
			#$Player_Weapon/Player_Weapon.position = Vector2(0, Length_from_player)
			pass
	
	
	if move_vec == Vector2.ZERO:
		animation_mode.travel("Idle")
	else:
		animation_mode.travel("Walking")
		animation_tree.set("parameters/Walking/blend_position", animation_vec)
		animation_tree.set("parameters/Idle/blend_position", animation_vec)
		move_and_collide(move_vec * MOVE_SPEED * delta)
	

func _input(event):
	if event.is_action_pressed("Swing"):
		match side:
			1:
				Weapon_animation_mode.travel("Gungeon_Charge_Left")
				$Player_Weapon/Left_ChargeTime.start()
			2:
				pass
			3:
				pass
			4:
				pass


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





func _on_Player_Weapon_Done(anim_name):
	print(anim_name)
	match anim_name:
		"Idle":
			print("done")
			pass
		"Gungeon_Charge_Left":
			print("starting Swing")
			var track_id = swing_left.find_track("Player_Weapon:position")
			var key_id = swing_left.track_find_key(1, 0.2, false)
			swing_left.track_set_key_value(track_id, key_id, $Cross_Hair/Position2D.position)
			Weapon_animation_mode.travel("Gungeon_Swing_Left")
		"Gungeon_Charge_Right":
			pass
		"Gungeon_Swing_Left":
			print("done swinging")
			Weapon_animation_mode.travel("Idle")
		"Gungeon_Swing_Right":
			pass
	
