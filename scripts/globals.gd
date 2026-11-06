extends Node
var has_shield = false
var shield = 0
var health: int = 100
var velocity: float
var score: int = 0
var fuel: float = 1000.0:
	set(value):
		if value < fuel:
			print("fuel ", fuel, " -> ", value)
			print_stack()
		fuel = value
var boosts: int = 0 #this shoukld range from 0 to 3 @Hazoro
signal out_of_fuel #if this is emmited, make the trail disappear and spx would go 3x slower
signal green_blob
var player:CharacterBody2D=null

const HOLD_TIME := 2.0
var pause_held_time := 0.0

func _process(delta: float) -> void:
	if player ==null:
		var fetched_player = get_tree().get_first_node_in_group("player")
		if player != null:
			player = fetched_player
	if Input.is_action_pressed("pause"):
		pause_held_time += delta
		if pause_held_time >= HOLD_TIME:
			get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	else:
		pause_held_time = 0.0
