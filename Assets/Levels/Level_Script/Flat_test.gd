extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node_or_null("Player_Catcher").connect("fire", self, "fire")
	get_node_or_null("Enemy_Type_2").connect("fire", self, "fire")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func fire(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)



func _on_Player_Catcher_catch(area):
	print(area.get_parent())
	area.get_parent().queue_free()

func _on_Level_Win():
	get_tree().call_group("enemy", "queue_free")
