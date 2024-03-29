extends Node2D
signal Done

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("Done", anim_name)


func _on_ChargeTime_timeout():
	emit_signal("Done", "Gungeon_Charge_Left")


func _on_Right_ChargeTime_timeout():
	emit_signal("Done", "Gungeon_Charge_Right")


func _on_Swing_timeout():
	emit_signal("Done", "Gungeon_Swing_Left")

func _on_FollowThrough_timeout():
	emit_signal("Done", "Followthrough")
