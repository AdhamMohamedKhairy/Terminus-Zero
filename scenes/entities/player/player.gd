extends CharacterBody2D



@onready var sprite:AnimatedSprite2D = $sprite
@onready var collision:CollisionShape2D = $collision
@onready var area:Area2D = $area
@onready var trail:Line2D = $line

const TRAIL_OFFSET := 20.0 # How far the trail can go

const THRUST_POWER := 600.0 # acceleration
const ROT_SPEED := 3.5 # for circular motion
const MAX_SPEED := 500.0 # so player doesnt become too fast
const DRAG := 0.3 # uhhh, claude helped me add it for friction
const BRAKE_POWER := 400.0 # pressing 'back' force
const BOOST_POWER := 1200.0
const BOOST_MAX_SPEED := 800.0

var trail_left_times:Array[float]=[]

func _ready():
	trail.top_level = true
	trail.global_position = Vector2.ZERO
	trail.clear_points()
	trail.z_index = -1
	trail.width = 16.0
	trail.default_color = Color8(81, 183, 201)
	
	
	var fade := Gradient.new()
	fade.set_color(0, Color8(81, 183, 201, 0))
	fade.set_color(1, Color8(81, 183, 201, 255))
	trail.gradient = fade

func _physics_process(delta: float) -> void:
	
	rotation += Input.get_axis("left","right") * ROT_SPEED * delta
	
	var forward_vector := Vector2.UP.rotated(rotation)
	var current_power := THRUST_POWER
	var speed_cap := MAX_SPEED
	
	if Input.is_action_pressed("boost"):
		speed_cap = BOOST_MAX_SPEED
		velocity += forward_vector * BOOST_POWER * delta
	elif Input.is_action_pressed("up"):
		velocity += forward_vector * THRUST_POWER * delta
	if Input.is_action_pressed("down"):
		velocity = velocity.move_toward(Vector2.ZERO, BRAKE_POWER*delta)
	
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
