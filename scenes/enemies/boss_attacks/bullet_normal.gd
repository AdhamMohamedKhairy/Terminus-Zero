extends Area2D

@export var dmg := 15
@export var direction :Vector2
@export var speed:=1200
func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area:Area2D):
	if area.is_in_group("hostile"):
		return
	$AnimatedSprite2D.play("collide")
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction*speed*delta
