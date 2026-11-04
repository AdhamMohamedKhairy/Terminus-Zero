extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var camera: Camera2D = $Camera
@onready var Player: CharacterBody2D = $Player
@onready var enemy_one: CharacterBody2D = $EnemyOne

var tile_size = 32
var chunk_size = 100
var view_distance = 16
var noise = FastNoiseLite.new()

var water_source_id = 2
var sand_source_id = 0
var grass_source_id = 1
var rock_source_id = 1

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	noise.frequency = 0.03
	view_distance = (chunk_size / 2) - 1
	load_chunk(0, 0)
	Player.position = Vector2((chunk_size * tile_size) / 2, (chunk_size * tile_size) / 2)

func load_chunk(x, y) -> void:
	tile_map.clear()
	for _x in range(chunk_size):
		for _y in range(chunk_size):
			var current_tile_position = Vector2i(_x + x, _y + y)
			var n = noise.get_noise_2d(current_tile_position.x, current_tile_position.y)
			var source_id: int
			if n < -0.3:
				source_id = water_source_id
			elif n < -0.1:
				source_id = sand_source_id
			elif n < 0.4:
				source_id = grass_source_id
			else:
				source_id = rock_source_id
			if tile_map.get_cell_source_id(0, current_tile_position) == -1:
				tile_map.set_cell(0, current_tile_position, source_id, Vector2i(0, 0))

func _physics_process(_delta: float) -> void:
	camera.position = Player.position
	var world_size = tile_map.get_used_rect() as Rect2i
	var world_size_start = world_size.position
	var world_size_end = world_size.end
	var player_position_poisitive = (Player.position / tile_size) + Vector2(view_distance, view_distance)
	var player_position_negative = (Player.position / tile_size) - Vector2(view_distance, view_distance)
	if player_position_poisitive.x > world_size_end.x :
		load_chunk(world_size_start.x + 1, world_size_start.y)
	elif player_position_negative.x < world_size_start.x:
		load_chunk(world_size_start.x - 1, world_size_start.y)
	if player_position_poisitive.y > world_size_end.y:
		load_chunk(world_size_start.x, world_size_start.y + 1)
	elif player_position_negative.y < world_size_start.y:
		load_chunk(world_size_start.x, world_size_start.y - 1)
	print("PLayer :", Player.global_position)
