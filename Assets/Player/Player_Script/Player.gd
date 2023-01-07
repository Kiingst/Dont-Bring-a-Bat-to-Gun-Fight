extends KinematicBody2D
export (int) var MOVE_SPEED = 300
export (int) var health = 3
var move_vec = Vector2.ZERO

signal take_damage
var alive = true
var floor_normal = Vector2(0, -1)

export (int) var Length_from_player
var side = 1

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float
export var double_jump = true
export var jump_count = 2
var count_num = 0

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
onready var Weapon_animation_tree = $Player_Weapon/AnimationTree
onready var Weapon_animation_mode = Weapon_animation_tree.get("parameters/playback")
onready var swing_left = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Swing")
onready var swing_right = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Swing_Right")
onready var follow_thr = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Followthrough_Left")

var swing_ready = false
var isSwinging = false
var charge_monitor = false

var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func Player_Control(delta):
	move_vec.y += get_gravity() * delta
	move_vec.x = get_input_velocity() * MOVE_SPEED
	
	if is_on_floor() == true:
		count_num = 0
	
	if double_jump == false:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump()
	else:
		if Input.is_action_just_pressed("jump") and count_num != jump_count:
			jump()
			count_num += 1
	
	move_vec = move_and_slide(move_vec, Vector2.UP)
	
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
	#Change Walking Animation
	if move_vec.x == 0:
		animation_mode.travel("Idle")
	else:
		animation_mode.travel("Walking")
		animation_tree.set("parameters/Walking/blend_position", look_vec.normalized() )
		animation_tree.set("parameters/Idle/blend_position", look_vec.normalized())
		
	
	if charge_monitor == true:
		match side:
			1:
				Weapon_animation_mode.travel("Gungeon_Charge_Left")
			3:
				Weapon_animation_mode.travel("Gungeon_Charge_Right")
				


func _input(event):
	if event.is_action_pressed("Swing"):
		match side:
			1:
				if swing_ready == false:
					Weapon_animation_mode.travel("Gungeon_Charge_Left")
					charge_monitor = true
				else:
					swing_ready = false
					charge_monitor = false
					swing(swing_left)
			2:
				pass
			3:
				if swing_ready == false:
					Weapon_animation_mode.travel("Gungeon_Charge_Right")
					charge_monitor = true
				else:
					charge_monitor = false
					swing_ready = false
					swing(swing_right)
					
			4:
				pass


func _physics_process(delta):
	if alive == false:
		return
	else:
		Player_Control(delta)
	
func swing(swing):
	isSwinging = true
	
	var look_vec = get_global_mouse_position() - global_position
	var keyvaluepos = look_vec.normalized() * Length_from_player
	var keyvaluerot = (rad2deg(look_vec.angle()) + 90) - 360
	ChangeAnimationValue(swing, "Player_Weapon:position", 0.2, keyvaluepos)
	ChangeAnimationValue(swing, "Player_Weapon:rotation_degrees", 0.2, keyvaluerot)
	var keyvaluefollow = keyvaluepos
	keyvaluefollow.x -= 20
	ChangeAnimationValue(follow_thr, "Player_Weapon:position", 0.2 , keyvaluefollow)
	ChangeAnimationValue(follow_thr, "Player_Weapon:position", 0 , keyvaluerot)
	match side:
		1:
			Weapon_animation_mode.travel("Left_Anticipation")
		3:
			Weapon_animation_mode.travel("Right_Anticipation")
			

#Next 3 func handels jumping and movement
func get_gravity() -> float:
	return jump_gravity if move_vec.y < 0.0 else fall_gravity
func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("Move_Left"):
		horizontal -= 1.0
	if Input.is_action_pressed("Move_Right"):
		horizontal += 1.0
	
	return horizontal
func jump():
	move_vec.y = jump_velocity
func ChangeAnimationValue(Animationname, trackname, time, keyvalue):
	var track_id = Animationname.find_track(trackname)
	var key_id = Animationname.track_find_key(track_id, time, false)
	Animationname.track_set_key_value(track_id, key_id, keyvalue)
	


func _on_Player_Weapon_Done(anim_name):
	match anim_name:
		"Idle":
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
	
