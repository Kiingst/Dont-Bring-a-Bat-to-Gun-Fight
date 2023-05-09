extends TextureRect
signal Selected_Upgrade(number)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Upgrades")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_1_pressed():
	Selected_Upgrade.emit(1)
	print("emitting one")

func _on_button_2_pressed():
	Selected_Upgrade.emit(2)
	print("emitting two")

func _on_button_3_pressed():
	Selected_Upgrade.emit(3)
	print("emitting three")

func set_data(Upgrade1_image,Upgrade1_text,Upgrade2_image,Upgrade2_text,Upgrade3_image,Upgrade3_text,):
	
	$MarginContainer/VBoxContainer/Inner_Box/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = Upgrade1_text
	$MarginContainer/VBoxContainer/Inner_Box/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Item_Image1.texture = Upgrade1_image

	$MarginContainer/VBoxContainer/Inner_Box2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Item_Image2.texture = Upgrade2_image
	$MarginContainer/VBoxContainer/Inner_Box2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label2.text =Upgrade2_text
	
	$MarginContainer/VBoxContainer/Inner_Box3/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label3.text =Upgrade3_text
	$MarginContainer/VBoxContainer/Inner_Box3/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Item_Image3.texture = Upgrade3_image




func _on_button_1_button_down():
	Selected_Upgrade.emit(1)
	print("emitting one")


func _on_button_1_mouse_entered():
	print("mouse entered")
