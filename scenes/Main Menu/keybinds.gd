extends Button

var action := ""
var previous_text := ""

"""
Used assistance from my old settings keybinding script
https://github.com/Hazorox/hot-reload/blob/main/scenes/MainMenu/control_change.gd
"""

func _ready():
	action = name
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			text = event.as_text_physical_keycode().trim_suffix(" - Physical")
	pressed.connect(_on_pressed)
	set_process_input(false)

func _on_pressed():
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:
			text = e.as_text()
	previous_text = text
	text = "?"
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo:
		get_viewport().set_input_as_handled()
		if event.keycode == KEY_ESCAPE:
			text = previous_text.trim_suffix(" - Physical")
		else:
			_rebind(event)
		set_process_input(false)

func _rebind(event:InputEventKey):
	if _check_key_taken(event):
		text = previous_text.trim_suffix(" - Physical")
		return
	
	for e in InputMap.action_get_events(action):
		if e is InputEventKey:
			InputMap.action_erase_event(action,e)
	var new_event := InputEventKey.new()
	new_event.physical_keycode = event.physical_keycode
	InputMap.action_add_event(action,new_event)
	text = new_event.as_text().trim_suffix(" - Physical")
	
func _check_key_taken(event:InputEventKey)->bool:
	for other in InputMap.get_actions():
		if other == action or other.begins_with("ui_"):
			continue
		for e in InputMap.action_get_events(other):
			if e is InputEventKey and e.physical_keycode == event.physical_keycode:
				return true
	return false
