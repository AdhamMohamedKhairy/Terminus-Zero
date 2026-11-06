extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var dmg:=10
var direction : Vector2 = Vector2.ZERO
var speed : int = 1000

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
