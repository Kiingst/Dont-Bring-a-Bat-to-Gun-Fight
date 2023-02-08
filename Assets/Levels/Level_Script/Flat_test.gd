extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("Player_Catcher") != null:
		get_node_or_null("Player_Catcher").connect("fire", self, "fire")
	get_node_or_null("Enemy_Type_2").connect("fire", self, "enemy_fire")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func fire(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _speed, _damage)
	
	
func fire2(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instance()
	add_child(b)
	_direction *= -1
	b.start(_position, _direction, _speed, _damage)


func enemy_fire(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _speed, _damage)
	b.connect("fire", self, "fire2")



func _on_Player_Catcher_catch(area):
	
	area.get_parent().queue_free()

func _on_Level_Win():
	get_tree().call_group("enemy", "queue_free")
