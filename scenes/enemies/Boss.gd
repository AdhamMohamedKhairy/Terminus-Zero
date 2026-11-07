extends CharacterBody2D

@onready var minion_scene : PackedScene = preload("uid://dp045jhs8b7dv")
@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var minion_count : int = 3
@export var minion_spawn_interval : float = 3.0
@export var SPEED := 1100
@export var health : int = 100
@export var THRUST_POWER : float = 1000.0
@export var MAX_SPEED : float = 450.0
@export var DRAG : float = 0.9
@export var ROT_SPEED : float = 10.0
@export var minion_spawn_radius : float = 80.0
@export var BRAKE_DISTANCE : float = 150.0
@export var STOP_DISTANCE : float = 60.0
const SHOT_COOLDOWN := 700
var shot_time = null
var should_chase : bool = false
var minion_spawn_timer : float = 0.0

func _physics_process(delta: float) -> void:
	$TextureProgressBar.value = health
	if should_chase:
			var to_player := player_node.global_position - global_position
			var distance : float = to_player.length()
			var target_angle := to_player.angle()
			rotation = rotate_toward(rotation, target_angle, ROT_SPEED * delta)
			var forward_vector := Vector2.RIGHT.rotated(rotation)
			if not $Area2D.overlaps_body(player_node):
				if distance > STOP_DISTANCE:
					var thrust_scale : float = clamp((distance - STOP_DISTANCE) / BRAKE_DISTANCE, 0.0, 1.0)
					velocity += forward_vector * THRUST_POWER * thrust_scale * delta
				else:
					velocity = velocity.move_toward(Vector2.ZERO, THRUST_POWER * delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, THRUST_POWER * delta)
			velocity = velocity.move_toward(Vector2.ZERO, DRAG * velocity.length() * delta)
			velocity = velocity.limit_length(MAX_SPEED)
			texture_progress_bar.value = health
			if health <= 0:
				die()
				return

			minion_spawn_timer -= delta
			if minion_spawn_timer <= 0.0:
				spawn_minions()
				minion_spawn_timer = minion_spawn_interval

			if should_chase:
				move_and_slide()

func die():
	set_physics_process(false)
	should_chase = false
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	Globals.score += 2
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if not should_chase:
			minion_spawn_timer = 0.0
		should_chase = true

	if area.is_in_group("player_attack"):
		health -= 10

func spawn_minions() -> void:
	if minion_scene == null:
		return
	for i in range(minion_count):
		var minion = minion_scene.instantiate()
		var angle = randf() * TAU
		var offset = Vector2.RIGHT.rotated(angle) * minion_spawn_radius
		minion.global_position = global_position + offset
		get_parent().add_child(minion)
