extends "res://Assets 4.0/Levels/base_room.gd"
#every room needs a marker 2d to place the door 
# and mutiple markers to place repesent the enemy spawn points 
#starting room has a place for the player
#each room will signal when and where to spawn a enemy at
#use a array with mutiple packed scenes in it and randomly chose an enemy to spawn

func add_values():
	enemy = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
	waves = 1
	wavesize = 1
	Time_between_waves = 30
	enemy1 = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
	enemy2  = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
	enemy3  = preload("res://Assets 4.0/Enemys/Test_Enemy/test_enemy.tscn")
