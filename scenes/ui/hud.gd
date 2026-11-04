extends Control
@onready var boost: AnimatedSprite2D = $Boost
@onready var health: TextureProgressBar = $HealthBar
@onready var shield: TextureProgressBar = $ShieldBar
@onready var gas: AnimatedSprite2D = $Gas
@onready var score: Label = $Label
@onready var fuel: Label = $Label2
@onready var hp: Label = $Label3
@onready var arrow: Sprite2D = $Arrow

func _ready() -> void:
	score.text = str(Globals.score) + " dwumstix"
	fuel.text = str(Globals.fuel) + "/1000"
	hp.text = str(Globals.health) + "HP"
	health.value = Globals.health
	shield.value = Globals.shield
	health.animation = "default"
	gas.frame = 4
	boost.frame = Globals.boosts
	gas.stop()
	health.stop()
	boost.stop()

func _process(delta: float) -> void:
	if Globals.velocity != 0:
		Globals.fuel -= Globals.velocity * 0.01
	if Globals.fuel <= 0:
		Globals.out_of_fuel.emit()
		gas.frame = 4
	if Globals.shield == 0:
		Globals.has_shield = false
	gas_frame_change()
	
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		arrow.hide()
		return
	else:
		arrow.show()
	
	var nearest: Node2D = null
	var nearest_dist := INF
	for i in get_tree().get_nodes_in_group("hostile"):
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
	if Globals.fuel >= 7500:
		gas.frame = 4
	elif Globals.fuel >= 5000:
		gas.frame = 3
	elif Globals.fuel >= 2500:
		gas.frame = 2
	elif Globals.fuel == 0:
		gas.fuel = 1
		
