extends "res://Assets/Player/Player_Script/Base_Player.gd"

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
var look_vec 
export (int) var balls_in_inventory 
signal catch
export (PackedScene) var ball
signal fire
export (int) var Bullet_Damage
export (int) var Bullet_Speed
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func Player_Control_Catch(delta):
	#print($offset/Catch_Area.get_overlapping_areas())
	
	
	look_vec = get_global_mouse_position() - global_position
	var look_ang = rad2deg(atan2(look_vec.y, look_vec.x))
	$Cross_Hair.global_rotation = atan2(look_vec.y, look_vec.x)
	$offset.global_rotation = atan2(look_vec.y, look_vec.x)
	
	
	if move_vec.x == 0:
		animation_mode.travel("Idle")
	else:
		animation_mode.travel("Walking")
		animation_tree.set("parameters/Walking/blend_position", look_vec.normalized() )
		animation_tree.set("parameters/Idle/blend_position", look_vec.normalized())

func _physics_process(delta):
	if alive == false:
		return
	else:
		Player_Control_Catch(delta)


func _input(event):
	if event.is_action_pressed("Parry"):
		catch()
	if event.is_action_pressed("Action"):
		throw()


func catch():
	for index in $offset/Catch_Area.get_overlapping_areas():
		if "Bullet" in index.name:
			print("caught ", index.get_parent())
			emit_signal("catch", index)
			balls_in_inventory += 1
		elif "Hit_Area" in index.name:
			print("caught ", index.get_parent())
			emit_signal("catch", index)
			balls_in_inventory += 1

func throw():
	if balls_in_inventory > 0:
		print("throwing")
		var direction = Vector2(1,0).rotated($Cross_Hair.global_rotation)
		emit_signal('fire', ball, $Cross_Hair/Position2D.global_position, direction, Bullet_Speed, Bullet_Damage)
		balls_in_inventory -= 1
