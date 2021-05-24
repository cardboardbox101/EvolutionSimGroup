extends Node2D

const CREATURE = preload("res://Creature/Scenes (creature)/Creature.tscn")
var rng = RandomNumberGenerator.new()
var arr = []
var arr2 = []
var lastCreature = 0
onready var timer = $Timer
onready var timer2 = $Timer2
onready var testTimer = $CreatureCountdown
var creature
var a = false
var x = 0

func _ready():
	var create
	for c in 250:
		create = CREATURE.instance()
		add_child(create)
		arr.append(create)
		create.init(rng.randi_range(3, 6), 250, 250, 50, 200, 150, 400, 1, 7, 1, 7, 1, 20, 0.1, 1, 0.1, 2, 0, 1, rng, true)
		create.position = $Position2D.position
	timer.wait_time = 3
	#timer.start()

	#IS THIS CODE NECCESARY?
	creature = CREATURE.instance()
	add_child(creature)
	creature.init(4, 250, 250, 50, 100, 150, 200, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1, rng, true)
	creature.position = $Position2D.global_position
	var creature2 = CREATURE.instance()
	add_child(creature2)
	arr.append(creature2)
	creature2.init(3, 250, 250, 50, 100, 150, 200, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1, rng, true)
	creature2._setGravity(0)
	creature2.position = $Position2D.global_position
	testCreatues()

func _on_Timer_timeout():
	x += 1
	#places creature in the screen
	for n in 1000:
		if (a):
			creature.queue_free()
		#creates creature
		creature = CREATURE.instance()
		add_child(creature)
		creature.init(rng.randi_range(3, 6), 150, 150, 50, 100, 150, 200, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1, true)
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
		newCreature.init(avg(creature1.nodeNumber, creature2.nodeNumber), 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,rng, false)
		newCreature.averageNodeAndJoints(creature1, creature2)

func killCreatures():
	#kills creatures
	#with the chance of death increasing the farther back in the array they are
	sortCreatures()
	
	var rand
	var numKilled = 0
	var numToKill = arr.size() / 2
	
	for n in arr.size():
		rand = rng.randi_range(0, arr.size())
		if rand < n and numKilled < numToKill:
			arr[n].queue_free()
			numKilled += 1
	if (numKilled < numToKill):
		for n in range (arr.size() - 1, 0, -1):
			arr[n].queue_free()
			numKilled += 1
	sortCreatures()

func newGeneration():
	killCreatures()
	breedCreatures()

func testCreatues():
	#TO BE WRITTEN
	testTimer.wait_time = 2
	testTimer.start()
	pass

func avg(num1, num2):
	#takes the average between two numbers
	return (num1 + num2) / 2

func getCreaturePosition():
	return creature.nodeAvgPos

func _on_CreatureCountdown_timeout():
	for crts in arr.size():
		arr[crts]._freezeJoints()
		arr[crts].distanceTravelled = abs(arr[crts].nodeAvgPos.x - arr[crts].originalNodeAvgPos.x)
#		print("Creature " + str(crts) + " | Final Pos: " + str(arr[crts].nodeAvgPos) + " | ABS of Distance: " + str(arr[crts].distanceTravelled))
	sortCreatures()
	for crts2 in arr.size():
		arr2.append(arr[crts2].distanceTravelled)
#	for dist in arr2.size():
#		print(str(arr2[dist]))
	testTimer.stop()
	newGeneration()
	pass # Replace with function body.
