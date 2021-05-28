extends Node2D
onready var simulation = preload("res://Creature/Scenes (creature)/MainScene.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var s = simulation.instance()
	add_child(s)
	pass # Replace with function body.
