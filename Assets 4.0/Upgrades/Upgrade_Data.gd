extends Node
var image
var text
var rng = RandomNumberGenerator.new()
var Common_Upgrades = []
var Rare_Upgrades = []
var Legendary_Upgrades = []

var expression = Expression.new()
var player

var Common_Upgrade_Dict = { 
	#Player_Upgrades
	"Speed" = ["res://icon.svg", "Move Faster" ,"player.move_speed += 100"],
	"Jump_Height" = ["res://icon.svg", "Jump Higher" ,"player.jump_height += 100"],
	"Dodge_Time" = ["res://icon.svg", " Dodge for 0.25 seconds longer" ,"player.invulnerability_time += 0.25"],
	"Health" = ["res://Assets 4.0/interface/heart.png", " +1 HP" ,"player.health += 1" ,],
	"Add_Jumps" = ["res://icon.svg", " +1 Jump" ,"player.jumps_available += 1"],
	"Auto_Pickup" = ["res://icon.svg", "Automatically pick up balls on the ground." ,"player.Auto_Pickup = true"],
	"Dodged_into_inventory" = ["res://icon.svg", "Dodged balls enter your inventory","[player.dodge_into_inventory = true]" ],
	"Add_Balls" = ["res://icon.svg", "+1 BaseBall","player.balls_in_inventory += 1" ]
	
	}

var Rare_Upgrade_Dict = {
	"Ball_Speed" = ["res://icon.svg", "Throw Faster","player.max_Bullet_Speed += 200" ],
	"Ball_Damage" = ["res://icon.svg", "+1 damage" ,"player.Bullet_Damage += 1"],
	"Ball_No_Player_Damage" = ["res://icon.svg", "Balls you thow dont hit you","player.Take_Own_Ball_damage = false" ]
}

	
func get_dict_from_chance():
	var random_num = rng.randi_range(0,100)
	if random_num <= 60:
		return Common_Upgrade_Dict
	elif random_num <= 90:
		return Rare_Upgrade_Dict
	else:
		return Rare_Upgrade_Dict

# Called when the node enters the scene tree for the first time.
func _ready():
	var array = get_tree().get_nodes_in_group("Player")
	player = array.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_upgrade():
	var dict = get_dict_from_chance()
	var key = dict.keys().pick_random()
	var array = dict.get(key)
	
	return [load(array[0]), array[1],array[2]]

func apply_Upgrade(array):
	
	run_script(array[2]) 
	#expression.parse(array[2])
	#var result = expression.execute([], self)
	#if expression.has_execute_failed():
	#	
	#	print("error:, ", expression.get_error_text())
	#else:
	#	print(result)


func run_script(input):
	var node = Node.new()
	add_child(node)
	var script = GDScript.new()
	
	script.set_source_code("extends Node\nfunc eval():\n\tvar array = get_tree().get_nodes_in_group('Player') \n\tvar player = array.pick_random() \n\t" + input)
	ResourceSaver.save(script, "res://testfile.gd");
	script.reload()
	node.set_script(script)
	node.eval()
	
	#var ref = RefCounted.new()
	#ref.set_script(script)
	#return ref.eval() # Supposing input is "23 + 2", returns 25
	
