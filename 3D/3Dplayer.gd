extends KinematicBody

export (int) var speed = 50
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_vec = Vector3()
	var roll_speed2 = 1
	if Input.is_action_pressed("Move_Up"):
		move_vec.z -= 1
	if Input.is_action_pressed("Move_Down"):
		move_vec.z += 1
	if Input.is_action_pressed("Move_Left"):
		move_vec.x -= 1
	if Input.is_action_pressed("Move_Right"):
		move_vec.x += 1
	if Input.is_action_pressed("Swing"):
		pass
	if Input.is_action_just_pressed("Roll"):
		pass
	move_vec = move_vec.normalized()
	move_and_slide(move_vec * speed)
	
	
