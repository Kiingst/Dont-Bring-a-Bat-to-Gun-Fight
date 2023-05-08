extends Control
@onready var ball = $MarginContainer/VBoxContainer/HBoxContainer/Ball
var player
var ball_count
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("res://Assets 4.0/Player/Catcher/Player_Catcher.tscn")
	ball_count = $MarginContainer/VBoxContainer/balls_in_inventory.get_children().size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.balls_in_inventory > ball_count:
		var how_many = player.balls_in_inventory - ball_count
		add_ball(how_many)
	

func add_ball(value):
	for i in value:
		$MarginContainer/VBoxContainer/balls_in_inventory.add_child(ball)
