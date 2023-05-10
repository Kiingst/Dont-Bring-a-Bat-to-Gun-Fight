extends RigidBody2D

var Bullet_Speed
var Bullet_Damage
var dir 
var Player_Owned = false
#var dead_ball = preload("res://Assets 4.0/Bullet/dead_baseball.tscn").instantiate()
var moving = true
var timerisrunning = false
signal dead
var collsion_counter = 0

func _ready():
	add_to_group("Baseballs")
	add_to_group("Active_Baseballs")
	set_angular_velocity(50)

var Bullet_velocity = Vector2()

func _on_Lifetime_timeout():
	kill_ball()

func start(_position, _direction, _speed, _damage):
	Bullet_Damage = _damage
	Bullet_Speed = _speed
	position = _position
	#rotation = _direction.angle()
	dir = _direction
	Bullet_velocity = _direction * _speed
	apply_central_impulse(Bullet_velocity)
	print("bullet firing at ", _speed, "speed doing ",Bullet_Damage," damage")

func _process(delta):
	if moving == false || collsion_counter == 5:
		kill_ball()


	if linear_velocity.length() < 20:
		if timerisrunning == false:
			$Stoped_Time.start()
			timerisrunning = true
	if Player_Owned == true:
		#$Sprite2D.modulate = Color(0,185,0,255)
		pass
	else:
		#$Sprite2D.modulate = Color(255,255,255,255)
		pass

func kill_ball():
	#emit_signal("dead", dead_ball, position)
	queue_free()

func _on_invincibility_timeout():
	$CollisionShape2D.disabled = false 


func _on_Bullet_body_entered(body):
	print(body.get_parent().name)
	if "Tilemap" in body.get_parent().name: 
		apply_central_impulse(Bullet_velocity)


func _on_stoped_time_timeout():
	timerisrunning = false
	if linear_velocity.length() < 50:
		moving = false


func _on_body_entered(body):
	collsion_counter += 1


func _on_baseball_area_area_entered(area):
	if "enemy" in area.name:
		
		area.get_parent().take_damage(Bullet_Damage)
		kill_ball()
	if "Player" in area.name:
		if area.get_parent().invulnerable == true:
			if area.get_parent().dodge_into_inventory == true:
				area.get_parent().balls_in_inventory += 1
				queue_free()
		else:
			area.get_parent().take_damage(Bullet_Damage)
			kill_ball()

