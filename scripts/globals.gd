extends Node
var has_shield = false
var shield = 0
var health := 200
var velocity: float
var score: int = 28
var player:CharacterBody2D = null
var fuel: float = 1000.0:
	set(value):
		#if value < fuel:
			#print("fuel ", fuel, " -> ", value)
			#print_stack()
		fuel = value
var boosts: int = 0 #this shoukld range from 0 to 3 @Hazoro
signal out_of_fuel #if this is emmited, make the trail disappear and spx would go 3x slower
signal green_blob

var won:=false
const HOLD_TIME := 3.0
var pause_held_time := 0.0

func _process(delta: float) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
	
	if is_instance_valid(player):
		health = player.health
	if Input.is_action_pressed("pause"):
		pause_held_time += delta
		if pause_held_time >= HOLD_TIME:
			# Wont reset here, to keep players stats
			get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	else:
		pause_held_time = 0.0
	
	if not won:
		if score>=30:
			won=true

func reset():
	health = 200
	shield = 0
	score = 0
	fuel = 1000.0
