extends RigidBody2D

var Bullet_Speed
var Bullet_Damage
var dir 
var kill = true
var Player_Owned = false
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
	print("bullet firing at ", _speed, "speed")

func _process(delta):
	print($CollisionShape2D.disabled)
	print(linear_velocity)
	if (linear_velocity.x >= -10 && linear_velocity.x < 10):
		$CollisionShape2D.disabled = true
	if Player_Owned == true:
		$Sprite2D.modulate = Color(0,185,0,255)
	else:
		$Sprite2D.modulate = Color(255,255,255,255)



func _on_invincibility_timeout():
	$CollisionShape2D.disabled = false 


func _on_Bullet_body_entered(body):
	print(body.get_parent().name)
	if "Tilemap" in body.get_parent().name: 
		apply_central_impulse(Bullet_velocity)
