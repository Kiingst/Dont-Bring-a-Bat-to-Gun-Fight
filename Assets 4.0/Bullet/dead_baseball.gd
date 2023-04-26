extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$RigidBody2D.position.y -= 100
	$RigidBody2D/Sprite2D.modulate = Color(0, 1, 0)
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_area_entered(area):
	if "Player" in area.name:
		area.get_parent().balls_in_inventory += 1
		queue_free()
		
