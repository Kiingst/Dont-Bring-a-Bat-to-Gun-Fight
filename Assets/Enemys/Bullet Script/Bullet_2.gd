extends Area2D

export (int) var Bullet_Speed
export (int) var Bullet_Damage
export (int) var Bullet_lifetime

func _ready():
	pass

var Bullet_velocity = Vector2()



func _on_Lifetime_timeout():
	queue_free()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = Bullet_lifetime
	Bullet_velocity = _direction * Bullet_Speed

func _process(delta):
	position += Bullet_velocity * delta

func _on_Bullet_2_body_entered(body):
#	if body.has_method('take_damage'):
#		body.take_damage(Bullet_Damage)
#		queue_free()
	pass

