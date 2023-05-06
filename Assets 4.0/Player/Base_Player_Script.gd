extends CharacterBody2D

@export var move_speed = 300
@export var health = 3
#var move_vec = Vector2.ZERO

signal took_damage
var alive = true
var floor_normal = Vector2(0, -1)
var trueifleft : bool


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

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	add_to_group("Player")


func Player_Control(delta):
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
		
	if is_on_wall() == false:
		iswall_sliding = false
	else:
		iswall_sliding = true
	
	if is_on_floor() == true:
		jump_counter = 0
	
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
		trueifleft = true
	if Input.is_action_pressed("Move_Right"):
		horizontal += 1.0
		trueifleft= false
	
	return horizontal

func jump():
	velocity.y = jump_velocity

func dash():
	do_dash.emit()
	print("signaled dash")
	
	
func take_damage(damage):
	health -= damage
