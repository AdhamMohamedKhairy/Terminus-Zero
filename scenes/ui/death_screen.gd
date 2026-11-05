extends CanvasLayer

@onready var explosion: AnimatedSprite2D = $Textures/Explosion
@onready var explosion_2: AnimatedSprite2D = $Textures/Explosion2
@onready var explosion_3: AnimatedSprite2D = $Textures/Explosion3
@onready var explosion_4: AnimatedSprite2D = $Textures/Explosion4
@onready var explosion_5: AnimatedSprite2D = $Textures/Explosion5
@onready var explosion_6: AnimatedSprite2D = $Textures/Explosion6
@onready var explosion_7: AnimatedSprite2D = $Textures/Explosion7
@onready var explosion_8: AnimatedSprite2D = $Textures/Explosion8
@onready var explosion_9: AnimatedSprite2D = $Textures/Explosion9
@onready var explosion_10: AnimatedSprite2D = $Textures/Explosion10
@onready var explosions: Array[AnimatedSprite2D] = [
	explosion, explosion_2, explosion_3, explosion_4, explosion_5,
	explosion_6, explosion_7, explosion_8, explosion_9, explosion_10
]

const AREA_MIN := Vector2(50, 100)
const AREA_MAX := Vector2(1230, 620)
const GRID_COLS := 5
const GRID_ROWS := 2

func _ready() -> void:
	for i in explosions.size():
		var sprite := explosions[i]
		sprite.animation_finished.connect(_on_explosion_finished.bind(sprite, i))
		randomize_explosion(sprite, i)

func _on_explosion_finished(sprite: AnimatedSprite2D, index: int) -> void:
	randomize_explosion(sprite, index)

func randomize_explosion(sprite: AnimatedSprite2D, index: int) -> void:
	sprite.play("animtion_" + str(randi_range(1, 3)))
	set_random_position(sprite, index)

func set_random_position(sprite: AnimatedSprite2D, index: int) -> void:
	var cell_width := (AREA_MAX.x - AREA_MIN.x) / GRID_COLS
	var cell_height := (AREA_MAX.y - AREA_MIN.y) / GRID_ROWS
	var col := index % GRID_COLS
	var row := index / GRID_COLS
	var cell_min := AREA_MIN + Vector2(col * cell_width, row * cell_height)
	var cell_max := cell_min + Vector2(cell_width, cell_height)
	sprite.global_position = Vector2(
		randf_range(cell_min.x, cell_max.x),
		randf_range(cell_min.y, cell_max.y)
	)

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
