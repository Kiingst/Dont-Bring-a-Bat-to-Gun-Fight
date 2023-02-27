extends RigidBody2D

var Bullet_Speed
var Bullet_Damage
var dir 
var kill = true


func _ready():
	add_to_group("Bullets")
	

var Bullet_velocity = Vector2()



func _on_Lifetime_timeout():
	if kill ==  true:
		queue_free()
	else :
		$Lifetime.start()

func start(_position, _direction, _speed, _damage):
	Bullet_Damage = _damage
	Bullet_Speed = _speed
	position = _position
	rotation = _direction.angle()
	dir = _direction
	Bullet_velocity = _direction * _speed
	apply_central_impulse(Bullet_velocity)

func _process(delta):
	pass
	#position += Bullet_velocity * delta
	#$Sprite.rotation_degrees += Bullet_Speed/20



func _on_invincibility_timeout():
	$CollisionShape2D.disabled = false 


func _on_Bullet_body_entered(body):
	print(body.get_parent().name)
	if "Tilemap" in body.get_parent().name: 
		apply_central_impulse(Bullet_velocity)
