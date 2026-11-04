extends CanvasLayer

var meteor_scene : PackedScene = load("res://scenes/ui/meteor.tscn")


func _on_meteor_timer_timeout() -> void:
	var meteor := meteor_scene.instantiate()
	$Meteors.add_child(meteor)


func _on_texture_button_pressed() -> void:
	print("one one")
