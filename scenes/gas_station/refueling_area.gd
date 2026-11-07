extends Area2D


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		await get_tree().create_timer(4).timeout
		
		var canvas := CanvasLayer.new()
		canvas.layer = 200
		var fade := ColorRect.new()
		fade.color = Color("#000")
		fade.modulate.a = 0
		fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		canvas.add_child(fade)
		get_parent().get_parent().add_child(canvas)
		
		var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(fade,"modulate:a",1,0.8)
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/cutscenes/earth.tscn")
		tween.tween_property(fade,"modulate:a",0,0.8)
