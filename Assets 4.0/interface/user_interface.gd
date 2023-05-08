extends Control
var ball = preload("res://Assets 4.0/interface/UIBall.tscn").instantiate()
var player
var ball_count
@onready var ball_array = $MarginContainer/VBoxContainer/balls_in_inventory.get_children()
@onready var ball2 = $MarginContainer/VBoxContainer/balls_in_inventory/Ball
# Called when the node enters the scene tree for the first time.
func _ready():
	var array = get_tree().get_nodes_in_group("Player")
	player = array.pick_random()
	inital_ball_visibility()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ball_count = $MarginContainer/VBoxContainer/balls_in_inventory.get_children().size()
	#print(player.balls_in_inventory, ball_count)
	#ball_array = $MarginContainer/VBoxContainer/balls_in_inventory.get_children()
	
	
	inital_ball_visibility()


func inital_ball_visibility():
	if player.balls_in_inventory > 0:
		for i in ball_array.size():
			#var ball_number = "Ball" + str(i)
			if player.balls_in_inventory >= i + 1:
				ball_array[i].visible = true
			else:
				ball_array[i].visible = false
			
			


func add_ball():
	if ball_count <= 0:
		print("adding_chiold")
		$MarginContainer/VBoxContainer/balls_in_inventory.add_child(ball)
	else:
		print("duplicating")
		ball2.duplicate()

func remove_ball():
	var w = $MarginContainer/VBoxContainer/balls_in_inventory.get_children().pick_random()
	$MarginContainer/VBoxContainer/balls_in_inventory.remove_child(w)
	
