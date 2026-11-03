extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction : Vector2 = Vector2.ZERO
var speed : int = 500

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
