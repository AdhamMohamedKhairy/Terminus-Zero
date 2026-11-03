extends CharacterBody2D

@export var health:= 100

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

func _ready():
	sprite.play("warp")
	await sprite.animation_finished
	sprite.play("idle")
	
	await get_tree().create_timer(2).timeout
	take_damage(200)

func _physics_process(delta: float) -> void:
	if dead:
		return
	rotation += Input.get_axis("left","right") * ROT_SPEED * delta
	
	var forward_vector := Vector2.UP.rotated(rotation)
	var current_power := THRUST_POWER
	var speed_cap := MAX_SPEED
	
	if Input.is_action_pressed("boost"):
		sprite.play("boost")
		speed_cap = BOOST_MAX_SPEED
		velocity += forward_vector * BOOST_POWER * delta
	elif Input.is_action_pressed("up"):
		sprite.play("boost")
		velocity += forward_vector * THRUST_POWER * delta
	if Input.is_action_pressed("down"):
		velocity = velocity.move_toward(Vector2.ZERO, BRAKE_POWER*delta)
	
	if Input.is_action_just_pressed("shoot"):
		shoot(forward_vector)
	
	
	
	velocity = velocity.move_toward(Vector2.ZERO,DRAG*velocity.length()*delta)
	velocity = velocity.limit_length(speed_cap)
	move_and_slide()
	
	update_trial(forward_vector)

func update_trial(forward_vector:Vector2)->void:
	var now := Time.get_ticks_msec() / 1000.0
	
	trail.add_point(global_position-forward_vector*TRAIL_OFFSET)
	trail_left_times.append(now)
	
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
