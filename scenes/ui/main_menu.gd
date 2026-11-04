extends CanvasLayer

var meteor_scene : PackedScene = load("res://scenes/ui/meteor.tscn")


func _on_meteor_timer_timeout() -> void:
	var meteor := meteor_scene.instantiate()
	$Meteors.add_child(meteor)


func _on_texture_button_pressed() -> void:
	#The start button
	get_tree().change_scene_to_file("res://scenes/ui/space.tscn")


func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main Menu/settings.tscn")

func _on_texture_button_3_pressed() -> void:
	#the modes button
	pass
