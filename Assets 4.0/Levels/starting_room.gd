extends Node2D
#every room needs a marker 2d to place the door 
# and mutiple markers to place repesent the enemy spawn points 
#starting room has a place for the player
#each room will signal when and where to spawn a enemy at
#use a array with mutiple packed scenes in it and randomly chose an enemy to spawn
var enemy : PackedScene = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
@export var waves : int = 1
@export var Time_between_waves = 30
@export var enemy1 : PackedScene
@export var enemy2 : PackedScene
@export var enemy3 : PackedScene

var current_wave = 0
var enemy_alive

signal level_clear
signal spawn_enemy


func _ready():
	$Timer.wait_time = Time_between_waves
	spawn_waves()

func spawn_waves():
	emit_signal("spawn_enemy", enemy, $Enemy.position)
	current_wave += 1
	$Timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_timer_timeout():
	if current_wave < waves :
		spawn_waves()
