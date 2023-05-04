extends Node2D
var activated = false
signal next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Doors")
	$Sprite2D.modulate = Color(0, 0, 0)

func activate():
	print("door activated")
	$Sprite2D.modulate = Color(1, 1, 1)
	activated = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if activated == true:
		if "interact" in area.name:
			next_level.emit()
			print("player entered door")
