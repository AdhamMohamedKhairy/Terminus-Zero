extends Node2D

const CELL := 600
const GEN_RADIUS := 3
const SAFE_DISTANCE := 500.0
const FUEL_SCORE := 30
const FUEL_DIST := 4000
@export var gas_scene: PackedScene
@export var enemy_one_scene: PackedScene = load("res://scenes/enemies/enemy_one.tscn")
@export var boss_scene: PackedScene = load("res://scenes/enemies/boss.tscn")
@onready var tile_map: TileMap = $TileMap
@onready var camera: Camera2D = $Camera
@onready var Player: CharacterBody2D = $Player
@onready var enemy_one: CharacterBody2D = $EnemyOne

var gas_spawned := false
var tile_size = 32
var chunk_size = 100
var view_distance = 16
var noise = FastNoiseLite.new()
var water_source_id = 2
var sand_source_id = 0
var grass_source_id = 1
var rock_source_id = 1
var gened: Dictionary = {}
var last_tile = Vector2i(99999,99999)
var station_spawns = false

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
	if not gas_spawned:
		if Globals.won:
			var copy = gas_scene.instantiate()
			copy.global_position = Globals.player.global_position + Vector2(400,400)
			add_child(copy)
			gas_spawned = true
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
		
	var player := Player
	#check_station(player)
	var cell = Vector2i((player.global_position / CELL).floor())
	if cell == last_tile:
		return
	last_tile = cell
	
	for x in range(cell.x - GEN_RADIUS, cell.x + GEN_RADIUS + 1):
		for y in range(cell.y - GEN_RADIUS, cell.y + GEN_RADIUS + 1): #also used claude to egt the range
			var c = Vector2i(x,y)
			if gened.has(c):
				continue
			gened[c] = true
			gened_cell(c, player)
			

func gened_cell(c: Vector2i, player: Node2D):
	if randi_range(1, 25) == 1:
		spawn(enemy_one_scene, c, player)
	if randi_range(1, 50) == 1:
		spawn(boss_scene, c, player)
		
func spawn(scene: PackedScene, c: Vector2i, player: Node2D):
	if scene == null:
		return
	var pos := Vector2(c * CELL) + Vector2(randf() * CELL, randf() * CELL)
	if pos.distance_to(player.global_position) <= SAFE_DISTANCE:
		return
	var node := scene.instantiate() as Node2D
	print("spawned ", scene.resource_path, " at ", pos)
	add_child(node)
	node.global_position = pos

#func check_station(x: Node2D):
	#if station_spawns or fuel_scen == null:
		#return
	#if Globals.score <= FUEL_SCORE:
		#return
	#station_spawns = true
	#var station = fuel_scen.instantiate() as Node2D
	#add_child(station)
	#station.global_position = x.global_position + Vector2.from_angle(randf() * TAU) * FUEL_DIST # claude helped me abit with this part
