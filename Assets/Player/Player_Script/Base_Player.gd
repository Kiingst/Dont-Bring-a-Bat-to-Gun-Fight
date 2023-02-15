extends KinematicBody2D

export (int) var MOVE_SPEED = 300
export (int) var health = 3
var move_vec = Vector2.ZERO

signal take_damage
var alive = true
var floor_normal = Vector2(0, -1)

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float
export var double_jump = true
export var jump_count = 2
var count_num = 0

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	

func _physics_process(delta):
	if alive == false:
		return
	else:
		Player_Control(delta)
	
	if health <= 0:
		alive = false
		remove_child($Player_Model)

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

func dash():
	MOVE_SPEED += 1000
	yield(get_tree().create_timer(0.15),"timeout")
	MOVE_SPEED -= 1000
	
func take_damage(damage):
	health -= damage
	

func _on_Player_area_entered(area):
	if "Bullet" in area.name:
		var w = area.get_parent()
		take_damage(w.Bullet_Damage)
		print("player took ",w.Bullet_Damage," damage from ", area )
		w.queue_free()
	elif "Hit_Area" in area.name:
		var w = area.get_parent()
		take_damage(w.Bullet_Damage)
		print("player took ",w.Bullet_Damage," damage from ", area )
		w.queue_free()
