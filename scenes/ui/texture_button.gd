extends TextureButton

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	$AnimatedSprite2D.play("hover")

func _on_mouse_exited() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
