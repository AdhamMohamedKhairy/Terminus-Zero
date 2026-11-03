extends Node

const BUBBLE = preload("res://scenes/ui/simple-dialogues/dialogue.tscn")
const WAIT_TIME := 2.0

var lines :Array[String]= []
var busy := false
var offset:Vector2=Vector2(-40,-40)
var target:Node2D
var bubble:PanelContainer

func toggle_buble(object:Node2D,bubble_offset:Vector2=Vector2.ZERO):
	target = object
	offset = bubble_offset


# Normal text queue
func queue_text(text:Array[String]):
	for txt in text:
		lines.append(text)
		if not busy:
			run_bubble()

func run_bubble():
	busy = true
	bubble  = BUBBLE.instantiate()
	
	add_child(bubble)
	
	while not lines.is_empty() and is_instance_valid(target):
		bubble.add_text(lines.pop_front())
		await get_tree().create_timer(WAIT_TIME).timeout
	
	bubble.queue_free()
	lines.clear()
	busy = false

func clear():
	lines.clear()

func _process(_delta: float):
	if busy and is_instance_valid(bubble) and is_instance_valid(target):
		bubble.global_position = target.global_position + offset -Vector2(bubble.size.x/2,bubble.size.y)
