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
	#timer.start()
	creature = CREATURE.instance()
	add_child(creature)
	creature.init(4, 250, 250, 50, 100, 150, 200, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1)
	creature.position = $Position2D.global_position

func _on_Timer_timeout():
	x += 1
	#places creature in the screen
	for n in 1000:
		if (a):
			creature.queue_free()
		#creates creature
		creature = CREATURE.instance()
		add_child(creature)
		creature.init(rng.randi_range(3, 6), 150, 150, 50, 100, 150, 200, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1)
		creature.position = $Position2D.global_position
		arr.append(creature)
	var x = 0
	var y = 0
	for n in arr.size():
		if x > 5000:
			y = y+200
			x=0
		if x< 5000:
			x = x+500
		if (arr[n] != null):
			# arr[n]._freezeJoints()
			arr[n].global_position = Vector2(x,y)

	a = true
	print("Ended Freezing")
	timer2.wait_time = 1
	timer2.start()

func _on_Timer2_timeout():
	for x in arr.size():
		arr[x]._unfreezeJoints()

	print("Unfrozen")
	pass # Replace with function body.

func sortCreatures():
	for i in range(arr.size()-1, -1, -1):
		for j in range(1,i+1,1):
			if arr[j-1].distanceTravelled > arr[j].distanceTravelled:
				var temp = arr[j-1]
				arr[j-1] = arr[j]
				arr[j] = temp

func breedCreatures():
	for n in arr.size() - 1:
		var creature1 = arr[n]
		var creature2 = arr[n + 1]
		
		var newCreature = CREATURE.instance()
		add_child(newCreature)
		newCreature.init(avg(creature1.nodeNumber, creature2.nodeNumber), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		newCreature.averageNodesAndJoints(creature1, creature2)
	#now the array is unsorted until creatures are tested again

func killCreatures():
	#kills creatures
	#with the chance of death increasing the farther back in the array they are
	sortCreatures()
	
	var rand
	var numKilled = 0
	
	for n in arr.size():
		rand = rng.randi_range(0, arr.size())
		if rand < n and numKilled < arr.size() / 2:
			arr.remove(n)
			numKilled += 1
	sortCreatures()

func newGeneration():
	killCreatures()
	breedCreatures()

func testCreatues():
	#TO BE WRITTEN
	pass

func avg(num1, num2):
	#takes the average between two numbers
	return (num1 + num2) / 2
