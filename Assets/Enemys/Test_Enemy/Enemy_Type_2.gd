extends KinematicBody2D
var bullet_speed = 100
var waittimer = Timer.new()
export (int) var health
export (int) var MOVE_SPEED
var On_Cooldown = false
signal fire 
signal death
#signal kill
export (PackedScene) var bullet

onready var player = get_parent().get_node("Player")

func _physics_process(delta):
	
	control(delta)


func move_to_player(delta):
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	

func kill():
	queue_free()

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
		emit_signal("kill", $pos.global_position)

func take_damage(damage):
	MOVE_SPEED -= 10
	health -= damage
	$HealthBar.visible = true

func damage_anamation():
	#$AnimatedSprite/damage_animation_legnth.start
	#for 
	#$AnimatedSprite.positionx  += 1
	pass

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

func _on_Enemy_Type_2_fire(bullet, _position, _direction):
	pass





