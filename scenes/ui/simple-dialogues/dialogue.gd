extends PanelContainer

@onready var label:Label=$Label

func add_text(text:String):
	label.text=text
	reset_size()
