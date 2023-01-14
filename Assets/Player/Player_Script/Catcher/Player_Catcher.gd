extends "res://Assets/Player/Player_Script/Base_Player.gd"

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
var look_vec 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Player_Control_Catch(delta):
	look_vec = get_global_mouse_position() - global_position
	var look_ang = rad2deg(atan2(look_vec.y, look_vec.x))
	$Cross_Hair.global_rotation = atan2(look_vec.y, look_vec.x)
	
	
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
	