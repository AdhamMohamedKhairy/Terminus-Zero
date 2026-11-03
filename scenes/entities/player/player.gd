extends CharacterBody2D

@export var health:= 100
@export var player_velocity:Vector2
@export var has_shield := false

@onready var shield_area :Area2D = $shield
@onready var shield_sprite : AnimatedSprite2D = $shield/AnimatedSprite2D
@onready var shield_collision:CollisionShape2D = $shield/CollisionShape2D

@onready var sprite:AnimatedSprite2D = $sprite
@onready var collision:CollisionShape2D = $collision
@onready var area:Area2D = $area
@onready var trail:Line2D = $line

# Bullet constants
const fire_ball_scene = preload("res://scenes/entities/player/fire_ball.tscn")
const BULLET_OFFSET = 40.0

# Trail Consts
const TRAIL_OFFSET := 20.0 # How far the trail can go

# Movement Constants
const THRUST_POWER := 600.0 # acceleration
const ROT_SPEED := 3.5 # for circular motion
const MAX_SPEED := 500.0 # so player doesnt become too fast
const DRAG := 0.3 # uhhh, claude helped me add it for friction
const BRAKE_POWER := 400.0 # pressing 'back' force
const BOOST_POWER := 1200.0
const BOOST_MAX_SPEED := 800.0

# Left time for each bit of trail
var trail_left_times:Array[float]=[]

var dead := false
var warping := true
func _ready():
	# Spawn, then idle
	sprite.play("warp")
	await sprite.animation_finished
	sprite.play("idle")
	await get_tree().create_timer(1).timeout
	Bubble.toggle_buble(self)
	Bubble.queue_text(["Hiiiii","Im Hamza"])
	warping = false
func _physics_process(delta: float) -> void:
	# No motion if dead
	if dead or warping:
		return
	
	# Rotate with left and right, move with up, brake with down
	rotation += Input.get_axis("left","right") * ROT_SPEED * delta
	
	var forward_vector := Vector2.UP.rotated(rotation) # Forward motion vector
	var current_power := THRUST_POWER
	var speed_cap := MAX_SPEED
	
	# play animation and modify velocity
	if Input.is_action_pressed("up"):
		sprite.play("boost")
		velocity += forward_vector * THRUST_POWER * delta
	elif Input.is_action_pressed("boost"):
		sprite.play("boost")
		speed_cap = BOOST_MAX_SPEED
		velocity += forward_vector * BOOST_POWER * delta
	
	# Brakes
	if Input.is_action_pressed("down"):
		velocity = velocity.move_toward(Vector2.ZERO, BRAKE_POWER*delta)
	
	# Shoot fireballs
	if Input.is_action_just_pressed("shoot"):
		shoot(forward_vector)
	
	
	# Drag force, then cap speed
	velocity = velocity.move_toward(Vector2.ZERO,DRAG*velocity.length()*delta)
	velocity = velocity.limit_length(speed_cap)
	
	# Export velocity for other usages
	player_velocity = velocity
	move_and_slide()
	
	# Update trail following the spaceship
	update_trail(forward_vector)

func update_trail(forward_vector:Vector2)->void:
	# Fetch current time for the new trail
	var now := Time.get_ticks_msec() / 1000.0
	
	# Add new trail with the current spawn time
	trail.add_point(global_position-forward_vector*TRAIL_OFFSET)
	trail_left_times.append(now)
	
	# Check for trails exceeding the limit of 1.0 seconds
	while trail_left_times.size() > 0 and now - trail_left_times[0] > 1.0:
		trail.remove_point(0)
		trail_left_times.pop_front()

func shoot(forward_vector:Vector2):
	var ball := fire_ball_scene.instantiate()
	
	# add to parent, instead of player
	get_parent().add_child(ball)
	
	ball.global_position = global_position + forward_vector * BULLET_OFFSET
	ball.rotation = rotation
	ball.direction = forward_vector

func take_damage(dmg:int):
	if has_shield:
		toggle_shield(false)
		return
	if dead:
		return
	health-=dmg
	if health <= 0:
		velocity = Vector2.ZERO
		collision.set_deferred("disabled",true)
		dead = true
		sprite.play("die")
		await sprite.animation_finished
		queue_free()

func toggle_shield(state:bool):
	print("TOGGLED")
	if state:
		shield_area.visible = true
		shield_sprite.play("spawn")
		await sprite.animation_finished
		shield_collision.set_deferred("disabled",false)
		shield_sprite.play("idle")
		has_shield = true
	else:
		shield_sprite.play("die")
		await shield_sprite.animation_finished
		shield_collision.set_deferred("disabled",true)
		shield_area.visible = false
		has_shield = false
