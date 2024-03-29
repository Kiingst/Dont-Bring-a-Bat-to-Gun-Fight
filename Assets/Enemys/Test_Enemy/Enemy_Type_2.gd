extends KinematicBody2D
var bullet_speed = 100
var waittimer = Timer.new()
export (int) var health
export (int) var MOVE_SPEED
var On_Cooldown = false
signal fire 
signal death
var alive = true
export (PackedScene) var bullet
onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

onready var player = get_parent().get_node("Player")

func _physics_process(delta):
	if alive == true:
		control(delta)


func move_to_player(delta):
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	

func kill():
	animation_mode.travel("Death")
	#emit_signal("kill", $pos.global_position)

var Current_Frame = 0


var Locked_On = false
var x = 0

func _ready():
	$HealthBar.max_value = health
	pass # Replace with function body.

func control(delta):
	if player == null:
		return
	$HealthBar.value = health
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	$gun.global_rotation = atan2(vec_to_player.y, vec_to_player.x)
	
	if Locked_On == false : 
			move_to_player(delta)
	elif Locked_On == true :
			fire()

	if health <= 0:
		kill()
		alive = false
		

func take_damage(damage):
	animation_mode.travel("damage_animation")
	MOVE_SPEED -= 10
	health -= damage
	$HealthBar.visible = true
	print("enemy took damage")
	

func fire():
	if On_Cooldown == false :
		On_Cooldown = true
		$Shoot_Cooldown.start()
		$gun.play()
		var direction = Vector2(1,0).rotated($gun.global_rotation)
		emit_signal('fire', bullet, $gun/Muzzle.global_position, direction)
		#print("gun muzzle position", $gun/Muzzle.global_position)
		#print("Bullet position",b.global_position)

#funcs that link to certain nodes of node


func _on_Shooting_Range_area_entered(area):
	if "Player" in area.name:
		Locked_On = true


func _on_Shooting_Range_area_exited(area):
	if "Player" in area.name:
		Locked_On = false


func _on_Shoot_Cooldown_timeout():
	On_Cooldown = false


func _on_gun_animation_finished():
	$gun.stop()


func _on_Enemy_area_entered(area):
	if "Hit_Area" in area.name:
		take_damage(1)


func _on_Timer_timeout():
	queue_free()
