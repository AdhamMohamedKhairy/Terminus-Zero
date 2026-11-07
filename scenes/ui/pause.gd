extends Control
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_open(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		set_open(not get_tree().paused)
		get_viewport().set_input_as_handled()

func set_open(open: bool):
	get_tree().paused = open
	for child in get_children():
		if child is CanvasLayer:
			child.visible = open
	
