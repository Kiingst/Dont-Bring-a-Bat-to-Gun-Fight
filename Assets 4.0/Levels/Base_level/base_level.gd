extends Node2D

var starting_level = preload("res://Assets 4.0/Levels/starting_room.tscn")
var room1 = preload("res://Assets 4.0/Levels/room1.tscn")
var islevelactive = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("Player") != null:
		get_node("Player").connect("fire",Callable(self,"fire"))
		get_node("Player").connect("caught",Callable(self,"_on_Player_Catcher_caught"))
	#get_node_or_null("Test_Enemy").connect("fire",Callable(self,"fire"))
	
	start(starting_level)
	


func start(level):
	addlevel(level)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(get_tree().get_nodes_in_group("Enemys").size())

func next_level():
	print("going to lext level")
	get_node("Room").queue_free()
	start(room1)

func addlevel(level1):
	var level = level1.instantiate()
	add_child(level)
	$Player.position = level.get_node("Player").position
	level.connect("spawn_enemy", Callable(self,"spawn_enemy"))
	level.connect("level_clear", Callable(self,"level_clear"))
	level.connect("next_level", Callable(self,"next_level"))

func level_clear():
	print("add reward")
	get_tree().call_group("Doors", "activate")

func fire(bullet, _position, _direction, _speed, _damage):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position,_direction, _speed,_damage)
	b.connect("dead", Callable(self,"dead_ball"))

func spawn_enemy(enemy, _position):
	print("actually spawing enemy")
	var e = enemy.instantiate()
	add_child(e)
	e.position = _position
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

