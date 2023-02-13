extends "res://Assets/baseball/script/Bullet.gd"
export (PackedScene) var player_bullet
signal fire


func switch(_position, _angle):
	var position1 = _position
	var rotation1 = _angle - PI
	var test = _angle - PI
	var direction1 = Vector2(1,0).rotated(test)
	emit_signal('fire', player_bullet, position1, direction1, Bullet_Speed, Bullet_Damage)
	#print(direction1)
	queue_free()


func _on_Bullet_area_entered(area):
	if "Hit" in area.name:
		var kill = false
		switch(position, rotation)

	

	#$Sprite.modulate = Color(0.69,0.88,0.72)
