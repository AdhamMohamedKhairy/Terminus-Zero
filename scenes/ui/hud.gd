extends Control
@onready var boost: AnimatedSprite2D = $Boost
@onready var health: TextureProgressBar = $HealthBar
@onready var shield: TextureProgressBar = $ShieldBar
@onready var gas: AnimatedSprite2D = $Gas
@onready var score: Label = $Label
@onready var fuel: Label = $Label2
@onready var hp: Label = $Label3
@onready var arrow: Sprite2D = $Arrow
@export var fuel_burn_rate := 1.0

func _ready() -> void:
	score.text = str(Globals.score) + " dwumstix"
	fuel.text = str(Globals.fuel) + "/1000"
	hp.text = str(Globals.health) + "HP"
	if Globals.has_shield == true:
		shield.value = 1
	else:
		shield.value = 0
	gas.frame = 4
	boost.frame = Globals.boosts
	gas.stop()
	boost.stop()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		var burn := fuel_burn_rate
		# Drain fuel faster,by multiplication of 3.5
		Globals.fuel = max(Globals.fuel - burn*3.5 * delta, 0.0)

func _process(delta: float) -> void:
	if Globals.fuel <= 0:
		Globals.out_of_fuel.emit()
	if Globals.shield == 0:
		Globals.has_shield = false

	update_display()
	gas_frame_change()
	update_arrow()

func update_display() -> void:
	score.text = str(Globals.score) + " dwumstix"
	fuel.text = str(int(Globals.fuel)) + "/1000"
	hp.text = str(Globals.health) + "HP"
	health.value = Globals.health
	shield.value = 1 if Globals.has_shield else 0
	boost.frame = Globals.boosts
	gas_frame_change()
	
func update_arrow():
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		arrow.hide()
		return
	else:
		arrow.show()
	
	var nearest: Node2D = null
	var nearest_dist := INF
	for i in get_tree().get_nodes_in_group("tracked_by_arrow"):
		var e := i as Node2D
		var d := player.global_position.distance_squared_to(e.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest = e
	
	if nearest == null:
		arrow.hide()
		return
	else: 
		arrow.show()
	
	arrow.show()
	var dir := nearest.global_position - player.global_position
	arrow.rotation = dir.angle() + PI/2
	
func gas_frame_change():
	if Globals.fuel >= 750:
		gas.frame = 4
	elif Globals.fuel >= 500:
		gas.frame = 3
	elif Globals.fuel >= 250:
		gas.frame = 2
	elif Globals.fuel > 0:
		gas.frame = 1
	else:
		gas.frame = 0
