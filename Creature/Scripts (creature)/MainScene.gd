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
var gen = 1
func _ready():
	var create
	for c in 250:
		create = CREATURE.instance()
		add_child(create)
		arr.append(create)
		create.init(rng.randi_range(3, 6), 250, 250, 50, 200, 150, 400, 1, 7, 1, 7, 1, 20, 0.1, 1, 0.1, 2, 0, 1, rng, true)
		create.position = $Position2D.position
		create.get_og_pos()
	creature = arr[0]
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
			if arr[j-1].distanceTravelled < arr[j].distanceTravelled:
				var temp = arr[j-1]
				arr[j-1] = arr[j]
				arr[j] = temp

func breedCreatures():
	for n in arr.size() - 1:
		var creature1 = arr[n]
		var creature2 = arr[n + 1]
		
		var newCreature = CREATURE.instance()
		add_child(newCreature)
		newCreature.init(avg(creature1.nodeNumber, creature2.nodeNumber), 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, rng, false)
		newCreature.averageNodeAndJoints(creature1, creature2)
		arr.append(newCreature)
		newCreature.get_og_pos()
	for n in 50:
		var newCreature = CREATURE.instance()
		add_child(newCreature)
		newCreature.init(rng.randi_range(3, 7), 150.00, 150.00, 50.00, 100.00, 150.00, 200.00, 1, 4, 1, 4, 1, 20, 0.1, 1, 0.1, 0.5, 0, 1,rng, true)
		arr.append(newCreature)
		newCreature.position = $Position2D.position
		newCreature.get_og_pos()
	#now the array is unsorted until creatures are tested again

func killCreatures():
	#kills creatures
	#with the chance of death increasing the farther back in the array they are
	sortCreatures()
	
	var rand
	var numKilled = 0
	print(arr.size())
	var numToKill = (arr.size() / 2) +25
	var deletedNums = []
	
	for n in arr.size():
		rand = rng.randi_range(10000000, arr.size())
		if rand < n and numKilled < numToKill:
			arr[n].queue_free()
			deletedNums.append(n)
			arr.remove(n)
			numKilled += 1
	if (numKilled < numToKill):
		for n in range (arr.size() - 1, 0, -1):
			if numKilled < numToKill:
				arr[n].queue_free()
				arr.remove(n)
				numKilled += 1
	print(arr.size())
#	for n in deletedNums.size():
#		arr.remove(n)
	var clen = 0
	while (clen<arr.size()):
		if (arr[clen] == null):
			arr.remove(clen)
		else:
			clen+=1
	print(arr.size())
	var nulls = 0
	for n in arr.size():
		if (arr[n] == null):
			nulls +=1
	print("Num of nulls = " + str(nulls))
	sortCreatures()

func newGeneration():
	killCreatures()
	breedCreatures()
	creature = arr[0]
	gen +=1

func testCreatues():
	#TO BE WRITTEN
	testTimer.wait_time = 15
	testTimer.start()
	pass

func avg(num1, num2):
	#takes the average between two numbers
	return (num1 + num2) / 2

func getCreaturePosition():
	return creature.nodeAvgPos

func _on_CreatureCountdown_timeout():
	print("Array Size at the begining of timer "+ str(arr.size()))
	var nulls = 0
	for n in arr.size():
		if (arr[n] == null):
			nulls +=1
	print("Num of nulls = " + str(nulls))
	for crts in arr.size():
		if(!arr[crts].travelCalculated):
			arr[crts].distanceTravelled = abs(arr[crts].nodeAvgPos.x - arr[crts].originalNodeAvgPos.x)
			arr[crts]._freezeJoints()
			arr[crts].travelCalculated = true
#		print("Creature " + str(crts) + " | Final Pos: " + str(arr[crts].nodeAvgPos) + " | ABS of Distance: " + str(arr[crts].distanceTravelled))
	sortCreatures()
	for crts2 in arr.size():
		arr2.append(arr[crts2].distanceTravelled)
#	for dist in arr2.size():
#		print(str(arr2[dist]))
	testTimer.stop()
	newGeneration()
	$Camera/RichTextLabel.text = "Generation: " + str(gen)
	$Camera/distDisplay.text = "Best Dist: " + str(_findFurthest())
	testTimer.start()
	pass # Replace with function body.

func _findFurthest():
	var highest = arr[0]
	var crts = 1
	while (crts<arr.size()):
		if (arr[crts].distanceTravelled > highest.distanceTravelled):
			highest = arr[crts]
		crts+=1
	return highest.distanceTravelled
