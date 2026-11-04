extends CharacterBody2D
@export var SPEED := 1100
var following_player:= false
var next_attack="bullet"
func _physics_process(delta: float) -> void:
	if Globals.player==null:
		return
	if global_position.distance_to(Globals.player.global_position) <= 200:
		following_player = true
	if not following_player:
		return
	velocity = global_position.direction_to(Globals.player.global_position)*SPEED*delta
	 
	move_and_slide()
