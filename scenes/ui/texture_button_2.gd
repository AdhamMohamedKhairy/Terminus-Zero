extends TextureButton

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	$IcePlanet.play("hover")

func _on_mouse_exited() -> void:
	$IcePlanet.stop()
	$IcePlanet.frame = 0
