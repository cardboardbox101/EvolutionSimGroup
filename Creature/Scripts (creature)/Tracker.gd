extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x = get_parent().arr[0].nodeAvgPos.x - 400
	global_position.y = get_parent().get_child(4).global_position.y - 260
	pass
