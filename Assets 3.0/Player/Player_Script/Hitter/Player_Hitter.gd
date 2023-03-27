extends "res://Assets/Player/Player_Script/Base_Player.gd"

@export (int) var Length_from_player
var side = 1
@export (bool) var canSwing = true
var keyvaluepos 
var keyvaluerot 
@export (int) var Bat_damage
@export (int) var bat_power


@onready var animation_tree = get_node("AnimationTree")
@onready var animation_mode = animation_tree.get("parameters/playback")
@onready var Weapon_animation_tree = $Player_Weapon/AnimationTree
@onready var Weapon_animation_mode = Weapon_animation_tree.get("parameters/playback")
@onready var swing_left = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Swing")
@onready var swing_right = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Swing_Right")
@onready var follow_thr = $Player_Weapon/AnimationPlayer.get_animation("Gungeon_Followthrough_Left")
var swing_ready = false
var isSwinging = false
var charge_monitor = false
var look_vec 


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player_Weapon.Bullet_Damage = Bat_damage

func Player_Control_Bat(delta):
	
	look_vec = get_global_mouse_position() - global_position
	var look_ang = rad_to_deg(atan2(look_vec.y, look_vec.x))
	$Cross_Hair.global_rotation = atan2(look_vec.y, look_vec.x)
	
	if swing_ready == false :
		$Player_Weapon.position = look_vec.normalized() * -20
	
	if look_ang > -30 && look_ang <= 0:
		side = 1
	elif look_ang >= 0 && look_ang <= 30:
		side = 1
	elif look_ang > 45 && look_ang <= 135:
		side = 2
	elif look_ang > 150 && look_ang <= 180:
		side = 3
	elif look_ang >= -180 && look_ang <= -150:
		side = 3
	elif look_ang > -135 && look_ang <= -45:
		side = 4
	
	if move_vec.x == 0:
		animation_mode.travel("Idle")
	else:
		animation_mode.travel("Walking")
		animation_tree.set("parameters/Walking/blend_position", look_vec.normalized() )
		animation_tree.set("parameters/Idle/blend_position", look_vec.normalized())
		
	

func _input(event):
	if event.is_action_pressed("Action"):
		if canSwing == true:
			print("Player is swinging")
			match side:
				1:
					swing(swing_left)
					canSwing = false
					$Swing_Cooldown.start()
				2:
					pass
				3:
					swing(swing_right)
					canSwing = false
					$Swing_Cooldown.start()
				4:
					pass
		else:
			print("Player swing is on cooldown")


func _physics_process(delta):
	if alive == false:
		return
	else:
		Player_Control_Bat(delta)
	
func swing(swing):
	isSwinging = true
	
	keyvaluepos = look_vec.normalized() * Length_from_player
	keyvaluerot = (rad_to_deg(look_vec.angle()) + 90) - 360
	ChangeAnimationValue(swing, "Player_Weapon:position", 0.2, keyvaluepos)
	ChangeAnimationValue(swing, "Player_Weapon:rotation_degrees", 0.2, keyvaluerot)
	var keyvaluefollow = keyvaluepos
	keyvaluefollow.x -= 20
	ChangeAnimationValue(follow_thr, "Player_Weapon:position", 0.2 , keyvaluefollow)
	ChangeAnimationValue(follow_thr, "Player_Weapon:position", 0 , keyvaluerot)
	$Player_Weapon/Swing.start()
	match side:
		1:
			Weapon_animation_mode.travel("Gungeon_Followthrough_Left")
		3:
			Weapon_animation_mode.travel("Gungeon_Followthrough_Right")
			

func ChangeAnimationValue(Animationname, trackname, time, keyvalue):
	var track_id = Animationname.find_track(trackname)
	var key_id = Animationname.track_find_key(track_id, time, false)
	Animationname.track_set_key_value(track_id, key_id, keyvalue)
	


func _on_Player_Weapon_Done(anim_name):
	match anim_name:
		"swing":
			Weapon_animation_mode.travel("Idle")




func _on_Swing_Cooldown_timeout():
	canSwing = true
	print("Player Swing off cooldown")


func _on_swing_movement_timeout():
	pass
	


func _on_Player_Weapon_ball(area):
	var w = area.get_parent()
	w.applied_force = Vector2(0,0)
	w.apply_central_impulse(look_vec.normalized() * bat_power)
