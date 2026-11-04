extends CharacterBody2D
const SPEED = 25.0
const ARC_ANGLE = rad_to_deg(50.0)
const ARC_RANGE = 400

var arc_side = 1.0

func _ready() -> void:
	arc_side = [1.0, -1.0].pick_random()

func _physics_process(delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		velocity = Vector2.ZERO
		return
	
	var to := player.global_position - global_position
	var dist := to.length()
	var arc = arc_side * ARC_ANGLE * clampf(dist / ARC_RANGE, 0.0, 1.0)
	velocity = to.normalized().rotated(arc) * SPEED

	move_and_slide()
