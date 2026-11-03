extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var camera: Camera2D = $Camera
@onready var Player: CharacterBody2D = $Player

var tile_size = 32
var chunk_size = 34
var view_distance = 16
var noise = FastNoiseLite.new()

var water_atlas_position = Vector2i(0, 0)
var sand_atlas_position = Vector2i(1, 0)
var grass_atlas_position = Vector2i(0, 2)

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
			var atlas_position: Vector2i
			var place_tile := true
			if n < -0.3:
				atlas_position = water_atlas_position
			elif n < -0.1:
				atlas_position = sand_atlas_position
			elif n < 0.4:
				atlas_position = grass_atlas_position
			else:
				place_tile = false
			if place_tile and tile_map.get_cell_source_id(0, current_tile_position) == -1:
				tile_map.set_cell(0, current_tile_position, 1, atlas_position)

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
