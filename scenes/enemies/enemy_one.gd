extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var bullet_scene = load("res://scenes/ui/enemy_one_lazer.tscn")

@export var health : int = 100

var speed : float = 65.0
var should_chase : bool = false

func _physics_process(delta: float) -> void:
	if should_chase:
		var direction = (player_node.global_position - global_position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5 * delta)
		move_and_slide()
		look_at(player_node.global_position)

func _on_enter_area_body_entered(body: Node2D) -> void:
	if body == player_node:
		should_chase = true

func _on_exit_area_body_exited(body: Node2D) -> void:
	if body == player_node:
		should_chase = false

func _on_bullet_timer_timeout() -> void:
	if should_chase == true:
		var direction = (player_node.global_position - global_position).normalized()
		var bullet = bullet_scene.instantiate()
		$"../EnemyBullets".add_child(bullet)
		bullet.global_position = $Marker2D.global_position
		bullet.rotation = direction.angle() + PI / 2
		bullet.direction = direction
