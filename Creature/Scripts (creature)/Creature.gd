extends Node2D

#scenes
const CIRCLE = preload("res://Creature/Scenes (creature)/Circle.tscn")
const JOINT = preload("res://Creature/Scenes (creature)/Joint.tscn")

#vars
var rng
var nodeNumber
var jointNumber

var nodes = []
var joints = []
var startingCreature = false

var distanceTravelled = 0

var originalNodeAvgPos = Vector2()
var nodeAvgPos = Vector2()
var originalCalculated = false

#method used for breeding
func averageNodeAndJoints(c1, c2):
	var smallest
	var j
	var j1
	var j2
	
	if c1.nodes.size() > c2.nodes.size():
		smallest = c2.nodes.size()
	else:
		smallest = c1.nodes.size()
	
	for n in smallest:
		get_node("circle_" + str(n)).global_position.x = (c1.get_node("circle_" + str(n)).global_position.x + c2.get_node("circle_" + str(n)).global_position.x) / 2
		get_node("circle_" + str(n)).global_position.y = (c1.get_node("circle_" + str(n)).global_position.y + c2.get_node("circle_" + str(n)).global_position.y) / 2
		get_node("circle_" + str(n)).friction =  (c1.get_node("circle_" + str(n)).friction + c2.get_node("circle_" + str(n)).friction) / 2
	
	#reset joint positions and rotations
	for n in jointNumber:
		j = get_node("joint_" + str(n))
		j1 = c1.get_node("joint_" + str(n))
		j2 = c2.get_node("joint_" + str(n))
		
		
		#get_node("joint_" + str(n)).position = Vector2((get_node("joint_" + str(n)).node_a.position.x + get_node("joint_" + str(n)).node_b.position.x) / 2, (get_node("joint_" + str(n)).node_a.position.y + get_node("joint_" + str(n)).node_b.position.y) / 2)
		#get_node("joint_" + str(n)).rotate(-(atan((get_node("joint_" + str(n)).node_a.position.x - get_node("joint_" + str(n)).node_b.position.x)/(get_node("joint_" + str(n)).node_a.position.y - get_node("joint_" + str(n)).node_b.position.y))))
		
		j.contractedLength = (j1.contractedLength + j2.contractedLength) / 2
		j.length = (j1.length + j2.length) / 2
		j.contractTime = (j1.contractTime + j2.contractTime) / 2
		j.expandTime = (j1.expandTime + j2.expandTime) / 2
		j.stiffness = (j1.stiffness + j2.stiffness) / 2
		j.damping = (j1.damping + j2.damping) / 2
		j.bias = (j1.bias + j2.bias) / 2

func _process(delta):
	if (!originalCalculated):
		for i in nodeNumber:
			originalNodeAvgPos.x += get_node("circle_" + str(i)).global_position.x
			originalNodeAvgPos.y += get_node("circle_" + str(i)).global_position.y
		originalNodeAvgPos.x = originalNodeAvgPos.x / nodeNumber
		originalNodeAvgPos.y = originalNodeAvgPos.y / nodeNumber
		originalCalculated = true
	else:
		for n in nodeNumber:
			nodeAvgPos.x += get_node("circle_" + str(n)).global_position.x
			nodeAvgPos.y += get_node("circle_" + str(n)).global_position.y
		nodeAvgPos.x = nodeAvgPos.x / nodeNumber
		nodeAvgPos.y = nodeAvgPos.y/ nodeNumber


#constructor, call manually with all values
func init(node_number : int, maxX, maxY, minCLen, maxCLen, minELen, maxELen, minCTime, maxCTime, minETime, maxETime, minStiff, maxStiff, minDamp, maxDamp, minBias, maxBias, minFric, maxFric, rang, starting):
	nodeNumber = node_number
	startingCreature = starting
	rng = rang
	#creating the circles (which are a scene)
	for n in nodeNumber:
		var circle = CIRCLE.instance()
		add_child(circle)
		circle.name = "circle_" + str(n)
		circle.position = Vector2(rng.randf_range(position.x - maxX, position.x + maxX), rng.randf_range(position.y - maxY, position.y + maxY))
		circle.friction = rng.randf_range(minFric, maxFric)
		nodes.append(circle.name)

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
		joint.name = "joint_" + str(n)
		joints.append(joint)
		#places the joint in between both circles
		joint.position = Vector2((nodeAPos.x + nodeBPos.x) / 2, (nodeAPos.y + nodeBPos.y) / 2)
		#uses inverse tangent to rotate the joint towards one of the circles
		joint.rotate(-(atan((nodeAPos.x - nodeBPos.x)/(nodeAPos.y - nodeBPos.y))))
		
		#initializes with random values in ranges given by the constructor
		joint.init(rng.randf_range(minCLen, maxCLen), rng.randf_range(minELen, maxELen), rng.randf_range(minCTime, maxCTime), rng.randf_range(minETime, maxETime), rng.randf_range(minStiff, maxStiff), rng.randf_range(minDamp, maxDamp), rng.randf_range(minBias, maxBias), nodePathA, nodePathB, false)

func _freezeJoints():
	for i in joints.size():
		joints[i].frozen = true
	
func _setGravity(newGrav):
	pass
		#nodes[i].gravity_scale = 0
func _unfreezeJoints():
	for i in joints.size():
		joints[i].frozen = false
		joints[i]._init_begin()
	print("all unfrozen")
