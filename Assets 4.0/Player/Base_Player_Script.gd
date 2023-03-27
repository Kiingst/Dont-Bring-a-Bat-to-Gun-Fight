extends CharacterBody2D

@export var move_speed = 300
@export var health = 3
var move_vec = Vector2.ZERO

signal took_damage
var alive = true
var floor_normal = Vector2(0, -1)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@export var do_multi_jump = true
@export var jumps_available = 2
var jump_counter = 0

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func Player_Control(delta):
	move_vec.y += get_gravity() * delta
	move_vec.x = get_input_velocity() * move_speed
	
	if is_on_floor() == true:
		jump_counter = 0
	
	if do_multi_jump == false:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump()
	else:
		if Input.is_action_just_pressed("jump") and jump_counter != jumps_available:
			jump()
			jump_counter += 1
	
	set_velocity(move_vec)
	set_up_direction(Vector2.UP)
	move_and_slide()
	move_vec = velocity

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
	move_speed += 1000
	await get_tree().create_timer(0.15).timeout
	move_speed -= 1000
	
func take_damage(damage):
	health -= damage
