extends TextureRect
signal Selected_Upgrade(number)
@onready var selector_one = $MarginContainer/VBoxContainer/Inner_Box/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button1/Selector
@onready var selector_two = $MarginContainer/VBoxContainer/Inner_Box2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button2/Selector
@onready var selector_three = $MarginContainer/VBoxContainer/Inner_Box3/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button3/Selector
var active = false
var current_selection = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Upgrades")
	set_current_selection(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_data(Upgrade1_image,Upgrade1_text,Upgrade2_image,Upgrade2_text,Upgrade3_image,Upgrade3_text):
	
	$MarginContainer/VBoxContainer/Inner_Box/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = Upgrade1_text
	$MarginContainer/VBoxContainer/Inner_Box/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Item_Image1.texture = Upgrade1_image

	$MarginContainer/VBoxContainer/Inner_Box2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Item_Image2.texture = Upgrade2_image
	$MarginContainer/VBoxContainer/Inner_Box2/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label2.text =Upgrade2_text
	
	$MarginContainer/VBoxContainer/Inner_Box3/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Label3.text =Upgrade3_text
	$MarginContainer/VBoxContainer/Inner_Box3/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/Item_Image3.texture = Upgrade3_image



func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text = ">"
		
func handle_selection(_current_selection):
	if _current_selection == 0:
		Selected_Upgrade.emit(1)
		print("emitting one")
	elif _current_selection == 1:
		Selected_Upgrade.emit(2)
		print("emitting two")
	elif _current_selection == 2:
		Selected_Upgrade.emit(3)
		print("emitting three")

func _input(event):
	if active == true:
		if Input.is_action_just_pressed("Move_Down") and current_selection < 2:
			current_selection += 1
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("Move_Up") and current_selection > 0:
			current_selection -= 1
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("ui_accept"):
			handle_selection(current_selection)
			active = false
