extends Control
@onready var boost: AnimatedSprite2D = $Boost
@onready var health: AnimatedSprite2D = $HealthBar
@onready var gas: AnimatedSprite2D = $Gas
@onready var score: Label = $Label
func _ready() -> void:
	score.text = str(Globals.score) + "dwumstix"
	boost.frame = 0
	health.animation = "default"
	health.frame = 0
	gas.frame = 4
	gas.stop()
	health.stop()
	boost.stop()

func _process(delta: float) -> void:
	pass
