extends Node2D
var simultaneous_scene = preload("res://BackGround.tscn").instance()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _add_a_scene_manually():
	 # This is like autoloading the scene, only
	# it happens after already loading the main scene.
	add_child(simultaneous_scene)
	var child = get_child(0)
	var newLoc = Vector2(lastSpace,0)
	child.translate(newLoc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
