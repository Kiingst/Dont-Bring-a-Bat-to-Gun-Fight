extends CharacterBody2D
var waittimer = Timer.new()
@export var health : int = 3



var On_Cooldown = false
signal fire 
signal death
var alive = true
@export var bullet : PackedScene
#@onready var animation_tree = get_node("AnimationTree")
#@onready var animation_mode = animation_tree.get("parameters/playback")
@export var Bullet_Damage : int = 1
@export var Bullet_Speed : int = 400
@onready var player = get_parent().get_node("Player")

var Current_Frame = 0


var Locked_On = false
var x = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var MOVE_SPEED : int = 50


func _ready():
	add_to_group("Enemys")
	#bullet.Bullet_Damage = Bullet_Damage
	#bullet.Bullet_Speed = Bullet_Speed
#	if get_node_or_null("Player_Catcher") != null:
#		player = get_parent().get_node("Player_Catcher")
#	else:
#		player = get_parent().get_node("Player_Hitter")
	$HealthBar.max_value = health




func _physics_process(delta):
	if alive == true:
		control(delta)


func move_to_player(delta):
	velocity.y += gravity * delta
	velocity.x = -MOVE_SPEED
	
	move_and_slide()

func kill():
	#animation_mode.travel("Death")
	queue_free()
	#emit_signal("kill", $pos.global_position)



func control(delta):
	if player == null:
		return
	$HealthBar.value = health
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	
	
	if Locked_On == false : 
			move_to_player(delta)
			pass
	elif Locked_On == true :
			$gun.global_rotation = atan2(vec_to_player.y, vec_to_player.x)
			if $gun/Line_of_sight.is_colliding() :
				dofire()
	
	if health <= 0:
		kill()
		alive = false
		


func take_damage(damage):
	if damage != null:
		#animation_mode.travel("damage_animation")
		MOVE_SPEED -= 10
		health -= damage
		$HealthBar.visible = true
	

func dofire():
	if On_Cooldown == false :
		On_Cooldown = true
		$Shoot_cooldown.start()
		var direction = Vector2(1,0).rotated($gun.global_rotation)
		emit_signal('fire', bullet, $gun/Muzzle.global_position, direction, Bullet_Speed, Bullet_Damage)
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




#func _on_Enemy_area_entered(area):
#	if "Hit" in area.name:
#		var w = area.get_parent()
#		take_damage(w.Bullet_Damage)
#		print("enemy took ", w.Bullet_Damage, " damge from, ", area)
#		w.queue_free()
#	elif "Bat" in area.name:
#		take_damage(area.get_parent().Bullet_Damage)
#		print("enemy took ", area.get_parent().Bullet_Damage, " damge from, ", area)


func _on_Timer_timeout():
	queue_free()


