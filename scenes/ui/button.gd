extends Button
func _on_pressed() -> void:
	get_parent().get_parent().set_open(false)
