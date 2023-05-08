extends Control
var ball = preload("res://Assets 4.0/interface/UIBall.tscn").instantiate()
var player
var ball_count
var ball_array
@onready var ball2 = $MarginContainer/VBoxContainer/balls_in_inventory/Ball
# Called when the node enters the scene tree for the first time.
func _ready():
	var array = get_tree().get_nodes_in_group("Player")
	player = array.pick_random()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ball_count = $MarginContainer/VBoxContainer/balls_in_inventory.get_children().size()
	#print(player.balls_in_inventory, ball_count)
	ball_array =$MarginContainer/VBoxContainer/balls_in_inventory.get_children()
	#print(idk[9])
	
		
	match player.balls_in_inventory:
		0:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball1.visible = false
		1:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball1.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball2.visible = false
		2:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball2.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball3.visible = false
		3:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball3.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball4.visible = false
		4:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball4.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball5.visible = false
		5:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball5.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball6.visible = false
		6:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball6.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball7.visible = false
		7:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball7.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball8.visible = false
		8:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball8.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball9.visible = false
		9:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball9.visible = true
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball10.visible = false
		10:
			$MarginContainer/VBoxContainer/balls_in_inventory/Ball10.visible = true


func inital_ball_visibility():
	if player.balls_in_inventory > 0:
		for i in ball_array.size():
			if ball_array[i].name contains "{i}":
				pass

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
	
