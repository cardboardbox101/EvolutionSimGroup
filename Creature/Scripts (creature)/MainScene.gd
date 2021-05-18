extends Node2D

const CREATURE = preload("res://Creature/Scenes (creature)/Creature.tscn")
var rng = RandomNumberGenerator.new()
var arr = []
onready var timer = $Timer
onready var timer2 = $Timer2
var creature
var a = false
var x = 0

func _ready():
	print("READY")
	timer.wait_time = 3
	timer.start()

#the code with the timer isn't neccessary to the final product
#it was just used to be able to see many creatures
func _on_Timer_timeout():
	x+=1 
	#places creature in the screen
	for n in 1000:
		if (a):
			creature.queue_free()
	
	#creates creature
		creature = CREATURE.instance()
		add_child(creature)
		creature.init(rng.randi_range(3, 6), 150, 150, 50, 100, 150, 200, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1)
		arr.append(creature)
		
	var x = 0
	var y = 0
	for n in arr.size():
		if x> 5000:
			y = y+200
			x=0
		if x< 5000:
			x = x+500 
		if (arr[n] != null):
			arr[n]._freezeJoints()
			arr[n].global_position = Vector2(x,y)
		
		
	a = true
	print("Ended Freezing")
	timer2.wait_time = 1
	timer2.start()
		
#alternate creature:
		#creature.init(rng.randi_range(3, 6), 150, 150, 20, 40, 60, 80, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1)

#idea: we could add different species that have different range values, or 
# one set of range values for every creature
# (the range values are whats sent to the constructor of the creature)


func _on_Timer2_timeout():
	for x in arr.size():
		arr[x]._unfreezeJoints()
			
	print("Unfrozen")
	pass # Replace with function body.
