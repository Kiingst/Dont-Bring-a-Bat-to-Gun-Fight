extends "res://Assets/baseball/script/Bullet.gd"




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Bullet_area_entered(area):
	if "Hit" in area.name:
		var kill = false
		startAng(position, rotation)
		switch()
		#$Enemy_Attack.set_name("Hit_Area")

	
func switch():
	$Bullet.monitorable = false
	$Bullet.monitoring = false
	$Hit_Area.monitorable = true
	$Hit_Area.monitoring = true
