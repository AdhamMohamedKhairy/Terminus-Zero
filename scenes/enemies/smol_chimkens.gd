extends CharacterBody2D

const SPEED = 200.0
const ARC_ANGLE = deg_to_rad(50.0)
const ARC_RANGE = 400

@export var damage_to_player: int = 5
@export var damage_cooldown: float = 1.0
@export var stand_off_distance: float = 30.0

var arc_side = 1.0
var damage_timer: float = 0.0

func _ready() -> void:
	arc_side = [1.0, -1.0].pick_random()

func _physics_process(delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		velocity = Vector2.ZERO
		return

	var to := player.global_position - global_position
	var dist := to.length()
	var direction := to.normalized()

	if dist > stand_off_distance:
		var arc = arc_side * ARC_ANGLE * clampf(dist / ARC_RANGE, 0.0, 1.0)
		velocity = direction.rotated(arc) * SPEED
	else:
		var tangent := direction.rotated(PI / 2.0 * arc_side)
		velocity = tangent * SPEED

	move_and_slide()

	if damage_timer > 0.0:
		damage_timer -= delta

	if $Area2D.overlaps_body(player) and damage_timer <= 0.0:
		if player.has_method("take_damage"):
			player.take_damage(damage_to_player)
		damage_timer = damage_cooldown

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Globals.green_blob.emit()
	if body.is_in_group("player_attack"):
		Globals.score += 1
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		Globals.score += 1
		queue_free()
