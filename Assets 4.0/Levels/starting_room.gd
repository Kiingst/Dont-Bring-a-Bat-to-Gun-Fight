extends Node2D
#every room needs a marker 2d to place the door 
# and mutiple markers to place repesent the enemy spawn points 
#starting room has a place for the player
#each room will signal when and where to spawn a enemy at
#use a array with mutiple packed scenes in it and randomly chose an enemy to spawn
var enemy : PackedScene = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
@export var waves : int = 1
@export var wavesize: int = 1
@export var Time_between_waves = 30
@export var enemy1 : PackedScene
@export var enemy2 : PackedScene
@export var enemy3 : PackedScene

var enemys = []
var current_wave = 0
var enemy_alive
var islevelclear = false

signal level_clear
signal spawn_enemy

func _ready():
	enemys.append(enemy1)
	$Timer.wait_time = Time_between_waves

func spawn_waves():
	spawn_enemys(1)
	current_wave += 1
	$Timer.start()
	get_tree().get_nodes_in_group("Enemys").size() == 0
	

func spawn_enemys(number):
	var i = 0
	while i < number:
		var e = enemys.pick_random()
		spawn_enemy.emit(enemy, $Enemy.position)
		i += 1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if islevelclear == false:
		if current_wave == waves && get_tree().get_nodes_in_group("Enemys").size() == 0:
			level_clear.emit()
			islevelclear = true



func _on_timer_timeout():
	if current_wave < waves :
		spawn_waves()


func _on_time_to_begin_timeout():
	spawn_waves()
