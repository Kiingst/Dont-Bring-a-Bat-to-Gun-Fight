extends Node2D
#every room needs a marker 2d to place the door 
# and mutiple markers to place repesent the enemy spawn points 
#starting room has a place for the player
#each room will signal when and where to spawn a enemy at
#use a array with mutiple packed scenes in it and randomly chose an enemy to spawn
var waves : int  
var wavesize: int 
var Time_between_waves : int 
var enemy1 : PackedScene 
var enemy2 : PackedScene 
var enemy3 : PackedScene 

var enemys = []
var current_wave = 0
var enemy_alive 
var islevelclear = false
@onready var enemy_spawn_array = $Enemy_Spawnpoints.get_children()
var enemy_spawn_array_deleted = []
#var enemypos = $Enemy_Spawnpoints.get_child_count()

signal level_clear
signal spawn_enemy
signal next_level

func _ready():
	add_to_group("Room")
	add_values()
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
		var s = enemy_spawn_array.pick_random()
		enemy_spawn_array_deleted.append(s)
		spawn_enemy.emit(e, s.position)
		enemy_spawn_array.erase(s)
		
		i += 1
	replace_deleted_spawnpoints()


func _process(delta):
	if islevelclear == false:
		if current_wave == waves && get_tree().get_nodes_in_group("Enemys").size() == 0:
			level_clear.emit()
			islevelclear = true
		elif current_wave > waves && get_tree().get_nodes_in_group("Enemys").size() == 0:
			$Timer.timeout.emit()

func replace_deleted_spawnpoints():
	for i in enemy_spawn_array_deleted.size():
		enemy_spawn_array.append(enemy_spawn_array_deleted[i])


func _on_timer_timeout():
	if current_wave < waves :
		spawn_waves()


func _on_time_to_begin_timeout():
	spawn_waves()


func _on_door_2_next_level():
	next_level.emit()

func add_values():
	pass
