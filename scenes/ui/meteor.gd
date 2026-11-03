extends Sprite2D

@onready var meteor: Sprite2D = $"."

@export var speed : int = 0
@export var direction_x : float = 0.0
@export var textures : Array[Texture]

func _ready() -> void:
	meteor.texture = textures.pick_random()
	var rng := RandomNumberGenerator.new()
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0, width)
	var random_y = rng.randi_range(-150, -50)
	position += Vector2(random_x, random_y)
	speed = rng.randi_range(400, 600)
	direction_x = rng.randf_range(-1, 1)

func _process(delta: float) -> void:
	position += Vector2(direction_x, 1.0) * speed * delta
	@warning_ignore("narrowing_conversion")
	speed += 10 * delta
	
