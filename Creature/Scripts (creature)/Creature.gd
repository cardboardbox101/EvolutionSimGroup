extends Node2D

#scenes
const CIRCLE = preload("res://Scenes/Circle.tscn")
const JOINT = preload("res://Scenes/Joint.tscn")

#vars
var rng = RandomNumberGenerator.new()
var nodeNumber
var jointNumber

#constructor, call manually with all values
func init(node_number : int, maxX, maxY, minCLen, maxCLen, minELen, maxELen, minCTime, maxCTime, minETime, maxETime, minStiff, maxStiff, minDamp, maxDamp, minBias, maxBias, minFric, maxFric):
	nodeNumber = node_number
	
	#creating the circles (which are a scene)
	for n in nodeNumber:
		var circle = CIRCLE.instance()
		add_child(circle)
		circle.name = "circle_" + str(n)
		circle.position = Vector2(rng.randf_range(position.x - maxX, position.x + maxX), rng.randf_range(position.y - maxY, position.y + maxY))
		circle.friction = rng.randf_range(minFric, maxFric)
	
	if (nodeNumber < 2):
		jointNumber = 0
	elif (nodeNumber == 2):
		jointNumber = 1
	else:
		jointNumber = nodeNumber
	
	#creating the joints
	for n in jointNumber:
		var circleA = "circle_" + str(n)
		var circleB
		if (n + 1 < nodeNumber):
			circleB = "circle_" + str(n + 1)
		else:
			circleB = "circle_0"
		#circles the joint connects
		
		var nodeA = get_node(circleA)
		var nodeB = get_node(circleB)
		var nodePathA = "../" + circleA
		var nodePathB = "../" + circleB
		var nodeAPos = nodeA.position
		var nodeBPos = nodeB.position
		
		var randBool = rng.randi_range(0, 1)
		if (randBool == 0):
			randBool = false
		else:
			randBool = true
		
		var joint = JOINT.instance()
		add_child(joint)
		
		#places the joint in between both circles
		joint.position = Vector2((nodeAPos.x + nodeBPos.x) / 2, (nodeAPos.y + nodeBPos.y) / 2)
		#uses inverse tangent to rotate the joint towards one of the circles
		joint.rotate(-(atan((nodeAPos.x - nodeBPos.x)/(nodeAPos.y - nodeBPos.y))))
		
		#initializes with random values in ranges given by the constructor
		joint.init(rng.randf_range(minCLen, maxCLen), rng.randf_range(minELen, maxELen), rng.randf_range(minCTime, maxCTime), rng.randf_range(minETime, maxETime), rng.randf_range(minStiff, maxStiff), rng.randf_range(minDamp, maxDamp), rng.randf_range(minBias, maxBias), nodePathA, nodePathB, randBool)
