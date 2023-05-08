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
@export var charge_increment : float
var currently_taking_damage = false
var charge: float
var invulnerable = false
var charging = false
var can_throw_ball = true
@export var max_balls_in_inventory = 10



func Player_Control_Catch(delta):
	if health <= 0:
		alive = false
	
	#look_vec = Input.get_vector("Left_stick_left", "Left_stick_right", "Left_stick_up", "Left_stick_down")
	look_vec = get_global_mouse_position() - global_position
	var look_ang = rad_to_deg(atan2(look_vec.y, look_vec.x))
	$Cross_Hair.global_rotation = atan2(look_vec.y, look_vec.x)
	$offset.global_rotation = atan2(look_vec.y, look_vec.x)
	
	$charge_bar.value = charge
	
	#if currently_taking_damage == false:
	#	if move_vec.x == 0:
	#		animation_mode.travel("Idle")
	#	else:
	#		animation_mode.travel("Walking")
	#		animation_tree.set("parameters/Walking/blend_position", look_vec.normalized() )
	#		animation_tree.set("parameters/Idle/blend_position", look_vec.normalized())
			
	
	
	#if Input.is_action_pressed("Charge"):
	#	if charge < 1:
	#		charge += charge_increment
	#		if charge > 1:
	#			charge = 1 
	#		print(charge)
	if balls_in_inventory <= 0 || throw_on_cooldown == true:
		can_throw_ball = false
	else:
		can_throw_ball = true
	
	if charging == true:
		if charge < 1:
			charge += charge_increment
		if charge > 1:
			charge = 1
			throw()
			charging = false
		#print(charge)
		



func _physics_process(delta):
	if alive == false:
		print("kill player")
		return
	else:
		Player_Control(delta)
		Player_Control_Catch(delta)

func _input(event):
	if event.is_action_pressed("Secondary_Action"):
		if catch_on_cooldown == false:
			catch()
			catch_on_cooldown = true
			$catch_cooldown.start()
	if event.is_action_pressed("Primary_Action"):
		if can_throw_ball == true:
			if charging == false:
				charging = true
			elif charging == true:
				throw()
				charging = false
	#if event.is_action_released("Primary_Action"):
	#		throw()
	if event.is_action_pressed("Pause"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("Dodge"):
		Dodge()
	if event.is_action_pressed("interact"):
		$interact/CollisionShape2D.disabled = false
		$interact/Time.start()

func take_damage(damage):
	
	if invulnerable == false :
		print("player took damage")
		#animation_mode.travel("Damage")
		health -= damage
		print(health)
	else :
		print("player is invulnerable")
	


func catch():
	for index in $offset/Catch_Area.get_overlapping_areas():
		if "Catch_Area" in index.name:
			print("caught ", index.get_parent())
			emit_signal("caught", index)
			
			add_ball_to_inventory(1)
			#balls_in_inventory += 1
			

func add_ball_to_inventory(value):
	if max_balls_in_inventory == balls_in_inventory and value > 0:
		#balls_in_inventory += value
		pass
	else:
		balls_in_inventory += value

func throw():
	if throw_on_cooldown == false:
		throw_on_cooldown = true
		$throw_cooldown.start()
		if balls_in_inventory > 0:
			#print("throwing")
			var direction = Vector2(1,0).rotated($Cross_Hair.global_rotation)
			emit_signal('fire', ball, $Cross_Hair/Marker2D.global_position, direction, base_Bullet_Speed + max_Bullet_Speed * charge, Bullet_Damage)
			charge = 0
			add_ball_to_inventory(-1)
		

func Dodge():
	invulnerable = true
	$Player_Model.modulate = Color(1,1,1,0.5)
	$invulnerability.start()

func _on_throw_cooldown_timeout():
	throw_on_cooldown = false


func _on_catch_cooldown_timeout():
	catch_on_cooldown = false



func _on_invulnerability_timeout():
	$Player_Model.modulate = Color(1,1,1,1)
	invulnerable = false


func _on_time_timeout():
	$interact/CollisionShape2D.disabled = true
