extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var bullet_scene = load("res://scenes/ui/enemy_one_lazer.tscn")
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var health : int = 100
@export var THRUST_POWER : float = 1000.0
@export var MAX_SPEED : float = 450.0
@export var DRAG : float = 0.9
@export var ROT_SPEED : float = 10.0
@export var BRAKE_DISTANCE : float = 150.0
@export var STOP_DISTANCE : float = 60.0
const SHOT_COOLDOWN := 700
var shot_time = null
var should_chase : bool = false

func _physics_process(delta: float) -> void:
	if should_chase:
		var to_player := player_node.global_position - global_position
		var distance : float = to_player.length()
		var target_angle := to_player.angle()
		rotation = rotate_toward(rotation, target_angle, ROT_SPEED * delta)
		var forward_vector := Vector2.RIGHT.rotated(rotation)
		if not $EnterArea.overlaps_body(player_node):
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
		if should_chase:
			move_and_slide()

func die():
	set_physics_process(false)
	should_chase = false
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	Globals.score += 2
	queue_free()

func _on_enter_area_body_entered(body: Node2D) -> void:
	if body == player_node:
		should_chase = true

func _on_bullet_timer_timeout() -> void:
	if should_chase == true:
		if shot_time == null or Time.get_ticks_msec() - shot_time>=SHOT_COOLDOWN:
			var direction = (player_node.global_position - global_position).normalized()
			var bullet = bullet_scene.instantiate()
			$"../EnemyBullets".add_child(bullet)
			bullet.global_position = $Marker2D.global_position
			bullet.rotation = direction.angle() + PI / 2
			bullet.direction = direction
			shot_time = Time.get_ticks_msec()
func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		health -= 15
