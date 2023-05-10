extends Control
var ball = preload("res://Assets 4.0/interface/UIBall.tscn").instantiate()
var player
var ball_count
@onready var ball_array = $MarginContainer/VBoxContainer/balls_in_inventory.get_children()
@onready var health_array = $MarginContainer/VBoxContainer/Vbox/Heath.get_children()
signal Selected_Upgrade
@onready var ball2 = $MarginContainer/VBoxContainer/balls_in_inventory/Ball 
@onready var upgrade_frame = $MarginContainer/VBoxContainer/MarginContainer/Frame
# Called when the node enters the scene tree for the first time.

func _ready():
	add_to_group("Ui")
	var array = get_tree().get_nodes_in_group("Player")
	player = array.pick_random()
	$MarginContainer/VBoxContainer/MarginContainer/Frame/Main_Frame.connect("Selected_Upgrade",Callable(self,"selected_upgrade_pass"))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ball_count = $MarginContainer/VBoxContainer/balls_in_inventory.get_children().size()
	#print(player.balls_in_inventory, ball_count)
	#ball_array = $MarginContainer/VBoxContainer/balls_in_inventory.get_children()
	
	visibility(health_array, player.health)
	visibility(ball_array, player.balls_in_inventory)
	
	if upgrade_frame.visible == true:
		get_tree().paused = true
	else:
		get_tree().paused = false


func visibility(array, value):
	if value >= 0:
		for i in array.size():
			if value >= i + 1:
				array[i].visible = true
			else:
				array[i].visible = false
			

func selected_upgrade_pass(amount):
	Selected_Upgrade.emit(amount)
	upgrade_frame.visible = false

func add_ball():
	if ball_count <= 0:
		print("adding_chiold")
		$MarginContainer/VBoxContainer/balls_in_inventory.add_child(ball)
	else:
		print("duplicating")
		ball2.duplicate()


func add_reward():
	print("adding reward")
	upgrade_frame.get_node("Main_Frame").active = true
	upgrade_frame.visible = true

