extends DampedSpringJoint2D

#vars
var defaultLength
var contractedLength

var contractTime
var expandTime

onready var timer = $Timer
var isExpanding

#for debug
func _print():
	print("Length")
	print(length)
	print("RestLength")
	print(rest_length)
	print("Stiffness")
	print(stiffness)
	print("Damping")
	print(damping)
	print("Bias")
	print(bias)

#start function (called by construtor)
func _init_begin():
		rest_length = contractedLength
		timer.wait_time = contractedLength
		timer.start()
		isExpanding = true

#repatedly called after "contract time" and "expand time" seconds have passed
func _on_Timer_timeout():
	#called when the timer runs out of time
	if (isExpanding):
		rest_length = length #expands length
		timer.wait_time = expandTime
		timer.start() #starts the timer to wait "wait_time" seconds
		isExpanding = false
	else:
		rest_length = contractedLength #contracts length
		timer.wait_time = contractedLength
		timer.start() #starts the timer to wait "wait_time" seconds
		isExpanding = true

#constructor, function is manually called when a new joint is constructed
func init(contracted_Length, expanded_Length, contract_Time, expand_Time, _stiffness, _damping, _bias, node1 : NodePath, node2: NodePath, startExpand):
	contractedLength = contracted_Length
	length = expanded_Length
	
	contractTime = contract_Time
	expandTime = expand_Time
	
	stiffness = _stiffness
	damping = _damping
	bias = _bias
	
	node_a = node1
	node_b = node2
	
	isExpanding = startExpand	
	
	_init_begin()
