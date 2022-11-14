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
onready var follow_thr = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Followthrough_Left")
var swing_ready = false
var isSwinging = false


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
	
	
	#print($Cross_Hair/Position2D.position)
	
	
	var look_vec = get_global_mouse_position() - global_position
	var look_ang = rad2deg(atan2(look_vec.y, look_vec.x))
	$Cross_Hair.global_rotation = atan2(look_vec.y, look_vec.x)
	
	if swing_ready == false :
		$Player_Weapon.position = look_vec.normalized() * -20
	
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
	
	#Set correct animation for bat position
	match side:
		1:
			#right
			if move_vec.x == -1:
				animation_vec.x = move_vec.x * -1
			else:
				animation_vec = move_vec
		2:
			#up
			if move_vec.y == -1:
				animation_vec.y = move_vec.y * -1
			else:
				animation_vec = move_vec
		3:
			#left
			if move_vec.x == 1:
				animation_vec.x = move_vec.x * -1
			else:
				animation_vec = move_vec
		4:
			#Down
			if move_vec.y == 1:
				animation_vec.y = move_vec.y * -1
			else:
				animation_vec = move_vec
	#Change Walking Animation
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
				if swing_ready == false:
					Weapon_animation_mode.travel("Gungeon_Charge_Left")
				else:
					swing()
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
	
func swing():
	isSwinging = true
	var look_vec = get_global_mouse_position() - global_position
	var keyvaluepos = look_vec.normalized() * 60
	var keyvaluerot = (rad2deg(look_vec.angle()) + 90) - 360
	print(keyvaluerot)
	ChangeAnimationValue(swing_left, "Player_Weapon:position", 0.2, keyvaluepos)
	ChangeAnimationValue(swing_left, "Player_Weapon:rotation_degrees", 0.2, keyvaluerot)
	var keyvaluefollow = keyvaluepos
	keyvaluefollow.x -= 20
	ChangeAnimationValue(follow_thr, "Player_Weapon:position", 0.2 , keyvaluefollow)
	ChangeAnimationValue(follow_thr, "Player_Weapon:position", 0 , keyvaluerot)
	print(keyvaluerot)
	Weapon_animation_mode.travel("Gungeon_Swing_Left")


func _on_Roll_timeout():
	#Stops Roll & restes move speed
	MOVE_SPEED = 300


func _on_Cooldown_timeout():
	#Roll taken off cooldown
	roll_On_cooldown = false
	print(roll_On_cooldown)

func Weapon_Pos(delta):
	pass
	
func ChangeAnimationValue(Animationname, trackname, time, keyvalue):
	var track_id = Animationname.find_track(trackname)
	var key_id = Animationname.track_find_key(track_id, time, false)
	Animationname.track_set_key_value(track_id, key_id, keyvalue)
	
	

func _on_Player_Weapon_Done(anim_name):
	match anim_name:
		"Idle":
			print("done")
			pass
		"Gungeon_Charge_Left":
			print("ready to swing")
			swing_ready = true
		"Gungeon_Charge_Right":
			pass
		"Gungeon_Swing_Left":
			Weapon_animation_mode.travel("Gungeon_Followthrough_Left")
		"Gungeon_Swing_Right":
			pass
		"Followthrough":
			Weapon_animation_mode.travel("Idle")
			isSwinging = false
			swing_ready = false
	
