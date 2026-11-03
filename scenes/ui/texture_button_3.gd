extends TextureButton

@onready var blue_gas_planet: AnimatedSprite2D = $BlueGasPlanet

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	blue_gas_planet.play("hover")

func _on_mouse_exited() -> void:
	blue_gas_planet.stop()
	blue_gas_planet.frame = 0
