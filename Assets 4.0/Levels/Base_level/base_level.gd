extends Node2D

var starting_level = preload("res://Assets 4.0/Bullet/dead_baseball.tscn").instantiate()
var islevelactive = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("Player") != null:
		get_node("Player").connect("fire",Callable(self,"fire"))
		get_node("Player").connect("caught",Callable(self,"_on_Player_Catcher_caught"))
	#get_node_or_null("Test_Enemy").connect("fire",Callable(self,"fire"))
	
	
	


func start():
	add_child(starting_level)
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if islevelactive == true:
		
		if get_tree().get_nodes_in_group("Enemys").size() == 0:
			print("activating doors")
			get_tree().call_group("Doors", "activate")
			islevelactive = false
			


func fire(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position,_direction, _speed,_damage)
	b.connect("dead", Callable(self,"dead_ball"))

func spawn_enemy(enemy, _position):
	var e = enemy.instantiate()
	add_child(e)
	e._position = _position
	e.connect("fire", Callable(self,"fire"))

func enemy_fire(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position,_direction,_speed,_damage)
	b.connect("fire",Callable(self,"fire2"))

func dead_ball(ball, _position):
	var ball2 = ball
	add_child(ball2)
	ball2.position = _position


func _on_Player_Catcher_caught(area):
	area.get_parent().queue_free()

func _on_Level_Win():
	get_tree().call_group("enemy", "queue_free")
