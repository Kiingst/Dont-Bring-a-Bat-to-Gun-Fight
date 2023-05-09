extends CharacterBody2D

@export var move_speed = 300
@export var health = 3
#var move_vec = Vector2.ZERO

signal took_damage
var alive = true
var floor_normal = Vector2(0, -1)


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var jump_height : float = 300
@export var jump_time_to_peak : float = 0.3
@export var jump_time_to_descent : float = 0.3
@export var do_multi_jump = true
@export var jumps_available = 2
var jump_counter = 0
var iswall_sliding = false
signal do_dash
var can_wall_jump = true
var last_input_right: bool
var is_Jumping: bool

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	add_to_group("Player")


func Player_Control(delta):
	#print(jump_counter)
	#print(can_wall_jump)
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
		
	if is_on_wall() == false:
		iswall_sliding = false
	else:
		iswall_sliding = true
	
	if iswall_sliding == true and can_wall_jump == true:
		jump_counter -= 1
		can_wall_jump = false
	
	if is_on_floor() == true:
		is_Jumping = false
		jump_counter = 0
		can_wall_jump = true
	
	if do_multi_jump == false:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			jump()
	else:
		if Input.is_action_just_pressed("Jump") and jump_counter != jumps_available:
			velocity.y += get_gravity() * delta
			jump()
			jump_counter += 1
	
	#set_velocity(move_vec)
	set_up_direction(Vector2.UP)
	#move_vec = velocity
	
	if iswall_sliding == true && velocity.y > 30:
		velocity.y = 50
		
	move_and_slide()

func _physics_process(delta):
	if alive == false:
		return
		
	else:
		#Player_Control_Catch(delta)
		Player_Control(delta)
	
	if health <= 0:
		alive = false
		remove_child($Player_Model)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	

func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("Move_Left"):
		horizontal -= 1.0
		last_input_right = false
	if Input.is_action_pressed("Move_Right"):
		horizontal += 1.0
		last_input_right = true
	
	return horizontal

func jump():
	is_Jumping = true
	velocity.y = jump_velocity

func dash():
	do_dash.emit()
	print("signaled dash")
	
	

