extends RigidBody2D

var Bullet_Speed
var Bullet_Damage
var dir 
var Player_Owned = false
var dead_ball = preload("res://Assets 4.0/Bullet/dead_baseball.tscn").instantiate()
var moving = true
var timerisrunning = false
signal dead

func _ready():
	add_to_group("Bullets")
	set_angular_velocity(200)

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
	print("bullet firing at ", _speed, "speed")

func _process(delta):
	if moving == false:
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
	print("ball died")
	emit_signal("dead", dead_ball, position)
	queue_free()

func _on_invincibility_timeout():
	$CollisionShape2D.disabled = false 


func _on_Bullet_body_entered(body):
	print(body.get_parent().name)
	if "Tilemap" in body.get_parent().name: 
		apply_central_impulse(Bullet_velocity)


func _on_stoped_time_timeout():
	timerisrunning = false
	if linear_velocity.length() < 20:
		moving = false


func _on_body_entered(body):
	print(body)


func _on_baseball_area_area_entered(area):
	if "enemy" in area.name:
		area.get_parent().take_damage(Bullet_Damage)
		queue_free()
