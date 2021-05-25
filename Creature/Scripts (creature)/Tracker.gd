extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.x = 0
	global_position.y = 650
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left"):
		global_position.x -= 100
	if Input.is_action_pressed("right"):
		global_position.x +=100
	pass


func _on_FurthestTimer_timeout():
	pass # Replace with function body.
