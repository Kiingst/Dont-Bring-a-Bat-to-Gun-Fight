extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("Player") != null:
		get_node("Player").connect("fire",Callable(self,"fire"))
		get_node("Player").connect("catch",Callable(self,"_on_Player_Catcher_catch"))
	get_node_or_null("Enemy_Type_2").connect("fire",Callable(self,"enemy_fire"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func fire(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instantiate()
	add_child(b)
	b.start(Callable(_position,_direction).bind(_speed),_damage)
	
	
func fire2(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instantiate()
	add_child(b)
	_direction *= -1
	b.start(Callable(_position,_direction).bind(_speed),_damage)


func enemy_fire(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instantiate()
	add_child(b)
	b.start(Callable(_position,_direction).bind(_speed),_damage)
	b.connect("fire",Callable(self,"fire2"))



func _on_Player_Catcher_catch(area):
	area.get_parent().queue_free()

func _on_Level_Win():
	get_tree().call_group("enemy", "queue_free")
