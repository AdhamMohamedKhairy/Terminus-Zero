extends Control

const SCROLL_SPEED := 40.0

@onready var scrollContainer:ScrollContainer = $ScrollContainer
var current_pos := 0.0
var scrolling := false
func _ready():
	scrollContainer.get_v_scroll_bar().modulate.a = 0.0
	await get_tree().create_timer(1.8).timeout
	scrolling = true

func _process(delta:float):
	if not scrolling:
		return
	var max_scroll := scrollContainer.get_v_scroll_bar().max_value - scrollContainer.size.y
	
	if current_pos < max_scroll:
		current_pos = minf(current_pos+ SCROLL_SPEED *delta,max_scroll)
		scrollContainer.scroll_vertical = int(current_pos)
