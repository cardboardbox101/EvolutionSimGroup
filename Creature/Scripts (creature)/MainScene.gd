extends Node2D

const CREATURE = preload("res://Creature/Scenes (creature)/MainScene.tscn")
var rng = RandomNumberGenerator.new()
onready var timer = $Timer
var creature
var a = false

func _ready():
	timer.wait_time = 3
	timer.start()

#the code with the timer isn't neccessary to the final product
#it was just used to be able to see many creatures
func _on_Timer_timeout():
	if (a):
		creature.queue_free()
	
	#creates creature
	creature = CREATURE.instance()
	add_child(creature)
	
	#places creature in the screen
	creature.position = Vector2(500, 250)
	creature.init(rng.randi_range(3, 6), 150, 150, 50, 100, 150, 200, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1)
	timer.wait_time = 3
	timer.start()
	
	a = true

#alternate creature:
		#creature.init(rng.randi_range(3, 6), 150, 150, 20, 40, 60, 80, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1)

#idea: we could add different species that have different range values, or 
# one set of range values for every creature
# (the range values are whats sent to the constructor of the creature)
