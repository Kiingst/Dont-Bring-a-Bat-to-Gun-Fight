extends RigidBody2D

export (int) var Bullet_Speed
export (int) var Bullet_Damage
export (int) var Bullet_lifetime
var dir 
var kill = true

func _ready():
	pass

var Bullet_velocity = Vector2()



func _on_Lifetime_timeout():
	if kill ==  true:
		queue_free()
	else :
		$Lifetime.start()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	dir = _direction
	$Lifetime.wait_time = Bullet_lifetime
	Bullet_velocity = _direction * Bullet_Speed
	$Lifetime.start()

func startAng(_position, _angle):
	position = _position
	rotation = _angle - PI
	var test = _angle - PI
	var direction = Vector2(1,0).rotated(test)
	$Lifetime.start()
	Bullet_velocity = direction * Bullet_Speed

func _process(delta):
	position += Bullet_velocity * delta


 

func _on_Hit_Area_area_entered(area):
	if "Hit" in area.name:
		var kill = false
		startAng(position, rotation)
		$Enemy_Attack.set_name("Hit_Area")
