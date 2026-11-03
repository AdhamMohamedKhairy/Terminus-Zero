extends Area2D

@export var direction := Vector2.UP
@export var speed := 1000.0

func _ready():
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += direction * speed*delta
