extends Node

onready var background = preload("res://Markers.tscn")
onready var lastSpace = 0
func _ready():
	var blankStr = 0
	for n in 4:
		var s = background.instance()
		add_child(s)
		var vec2 = Vector2(lastSpace,398.5)
		s.translate(vec2)
		s.get_child(1).text = String(blankStr)
		s.z_index = 100
		blankStr+=1
		lastSpace+=250
	pass # Replace with function body.

