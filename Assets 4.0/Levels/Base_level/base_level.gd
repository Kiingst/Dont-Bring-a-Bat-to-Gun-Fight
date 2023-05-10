extends Node2D

var starting_level = preload("res://Assets 4.0/Levels/starting_room.tscn")
var room1 = preload("res://Assets 4.0/Levels/room1.tscn")
var room2 = preload("res://Assets 4.0/Levels/room2.tscn")
var room3 = preload("res://Assets 4.0/Levels/room3.tscn")
var room_array = [starting_level, room1, room2, room3]
var room_array_index = 0

var islevelactive = true
var Upgrade1
var Upgrade2
var Upgrade3

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node_or_null("Player") != null:
		get_node("Player").connect("fire",Callable(self,"fire"))
		get_node("Player").connect("caught",Callable(self,"_on_Player_Catcher_caught"))
	#get_node_or_null("Test_Enemy").connect("fire",Callable(self,"fire"))
	
	start(room_array[room_array_index])
	


func start(level):
	addlevel(level)
	room_array_index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(get_tree().get_nodes_in_group("Enemys").size())

func next_level():
	print("going to lext level")
	get_tree().call_group("Baseballs", "queue_free")
	get_tree().call_group("Room", "queue_free")
	start(room_array[room_array_index])

func addlevel(level1):
	var level = level1.instantiate()
	add_child(level)
	$Player.position = level.get_node("Player").position
	level.connect("spawn_enemy", Callable(self,"spawn_enemy"))
	level.connect("level_clear", Callable(self,"level_clear"))
	level.connect("next_level", Callable(self,"next_level"))

func level_clear():
	#print("add reward")
	set_upgrade_data()
	get_tree().call_group("Active_Baseballs", "queue_free")
	get_tree().call_group("Ui", "add_reward")
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

func set_upgrade_data():
	Upgrade1 = $Upgrade_Data.get_upgrade()
	Upgrade2 = $Upgrade_Data.get_upgrade()
	Upgrade3 = $Upgrade_Data.get_upgrade()
	get_tree().call_group("Upgrades", "set_data", Upgrade1[0],Upgrade1[1],Upgrade2[0],Upgrade2[1],Upgrade3[0],Upgrade3[1])

#func get_rand_upgrade():
#	var array = $Upgrade_Data.get_upgrade()
#	return array

func _on_player_do_dash():
	
	$Player.position.x += 50


func _on_user_interface_selected_upgrade(amount):
	print("Upgrade ",amount," was selected")
	match amount:
		1:
			$Upgrade_Data.apply_Upgrade(Upgrade1)
		2:
			$Upgrade_Data.apply_Upgrade(Upgrade2)
		3:
			$Upgrade_Data.apply_Upgrade(Upgrade3)
	
