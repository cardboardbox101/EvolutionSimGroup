extends Node

onready var background = preload("res://BackGroundsAndPlacements/BackGround.tscn")
onready var lastSpace = 0
func _ready():
	for n in 500:
		var s = background.instance()
		add_child(s)
		var vec2 = Vector2(lastSpace,0)
		s.translate(vec2)
		lastSpace+=499
	pass # Replace with function body.
