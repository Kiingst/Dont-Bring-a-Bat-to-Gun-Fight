extends "res://Assets 4.0/Player/Base_Player_Script.gd"

#@onready var animation_tree = get_node("AnimationTree")
#@onready var animation_mode = animation_tree.get("parameters/playback")
var look_vec 
var throw_on_cooldown = false
var catch_on_cooldown = false
@export var balls_in_inventory : int
signal caught
@export var ball : PackedScene
signal fire
@export var Bullet_Damage : int
@export var max_Bullet_Speed : int
@export var base_Bullet_Speed : int
@export var charge_increment : int
var currently_taking_damage = false


func Player_Control_Catch(delta):
	#print($offset/Catch_Area.get_overlapping_areas())
	
	
	look_vec = get_global_mouse_position() - global_position
	var look_ang = rad_to_deg(atan2(look_vec.y, look_vec.x))
	$Cross_Hair.global_rotation = atan2(look_vec.y, look_vec.x)
	$offset.global_rotation = atan2(look_vec.y, look_vec.x)
	
	#if currently_taking_damage == false:
	#	if move_vec.x == 0:
	#		animation_mode.travel("Idle")
	#	else:
	#		animation_mode.travel("Walking")
	#		animation_tree.set("parameters/Walking/blend_position", look_vec.normalized() )
	#		animation_tree.set("parameters/Idle/blend_position", look_vec.normalized())
			
	
	
	if Input.is_action_pressed("Charge"):
		$charge_bar.value += charge_increment
		print($charge_bar.value)

func _physics_process(delta):
	if alive == false:
		return
	else:
		Player_Control(delta)
		Player_Control_Catch(delta)

func _input(event):
	if event.is_action_pressed("Parry"):
		if catch_on_cooldown == false:
			catch()
			catch_on_cooldown = true
			$catch_cooldown.start()
	if event.is_action_pressed("Action"):
		if throw_on_cooldown == false:
			throw()
			throw_on_cooldown = true
			$throw_cooldown.start()
	if event.is_action_pressed("reset_scene"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("dash"):
		dash()

func take_damage(damage):
	currently_taking_damage = true
	print("doing damage animation")
	#animation_mode.travel("Damage")
	health -= damage
	


func catch():
	for index in $offset/Catch_Area.get_overlapping_areas():
		if "catch_area" in index.name:
			print("caught ", index.get_parent())
			emit_signal("caught", index)
			balls_in_inventory += 1

func throw():
	if balls_in_inventory > 0:
		print("throwing")
		var direction = Vector2(1,0).rotated($Cross_Hair.global_rotation)
		emit_signal('fire', ball, $Cross_Hair/Marker2D.global_position, direction, base_Bullet_Speed + max_Bullet_Speed * $charge_bar.value, Bullet_Damage)
		$charge_bar.value = 0
		balls_in_inventory -= 1
		


func _on_throw_cooldown_timeout():
	throw_on_cooldown = false


func _on_catch_cooldown_timeout():
	catch_on_cooldown = false

