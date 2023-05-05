extends Node2D
#every room needs a marker 2d to place the door 
# and mutiple markers to place repesent the enemy spawn points 
#starting room has a place for the player
#each room will signal when and where to spawn a enemy at
#use a array with mutiple packed scenes in it and randomly chose an enemy to spawn
var enemy : PackedScene = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
var waves : int  = 2
var wavesize: int = 3
var Time_between_waves : int = 30
var enemy1 : PackedScene = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
var enemy2 : PackedScene = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
var enemy3 : PackedScene = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")

var enemys = []
var current_wave = 0
var enemy_alive
var islevelclear = false
#var enemypos = $Enemy_Spawnpoints.get_child_count()

signal level_clear
signal spawn_enemy
signal next_level

func _ready():
	enemys.append(enemy1)
	enemys.append(enemy2)
	enemys.append(enemy3)
	$Timer.wait_time = Time_between_waves

func spawn_waves():
	spawn_enemys(wavesize)
	current_wave += 1
	$Timer.start()
	get_tree().get_nodes_in_group("Enemys").size() == 0
	

func spawn_enemys(number):
	var i = 0
	while i < number:
		var e = enemys.pick_random()
		spawn_enemy.emit(e, $Enemy_Spawnpoints.get_children().pick_random().position)
		i += 1


func _process(delta):
	if islevelclear == false:
		if current_wave == waves && get_tree().get_nodes_in_group("Enemys").size() == 0:
			level_clear.emit()
			islevelclear = true
		elif current_wave > waves && get_tree().get_nodes_in_group("Enemys").size() == 0:
			$Timer.timeout.emit()



func _on_timer_timeout():
	if current_wave < waves :
		spawn_waves()


func _on_time_to_begin_timeout():
	spawn_waves()


func _on_door_2_next_level():
	next_level.emit()
