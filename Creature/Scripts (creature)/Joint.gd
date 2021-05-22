extends DampedSpringJoint2D

#vars
var defaultLength
var contractedLength
var contractedLength2

var contractTime
var expandTime

onready var timer = $Timer
var isExpanding
var frozen = false

onready var sprite

var constructed = false

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

func _process(delta):
	if (constructed):
		sprite.scale.y = 5
		sprite.global_scale.x = sqrt(pow((get_node(node_a).global_position.x - get_node(node_b).global_position.x), 2) + pow((get_node(node_a).global_position.y - get_node(node_b).global_position.y), 2))
		global_position = Vector2((get_node(node_a).global_position.x + get_node(node_b).global_position.x) / 2, (get_node(node_a).global_position.y + get_node(node_b).global_position.y) / 2)
		global_rotation = (atan2(get_node(node_a).global_position.y - get_node(node_b).global_position.y, get_node(node_a).global_position.x - get_node(node_b).global_position.x))
		
#		sprite.scale.y = 5
#		sprite.global_scale.x = sqrt(pow((get_node(node_a).global_position.x - get_node(node_b).global_position.x), 2) + pow((get_node(node_a).global_position.y - get_node(node_b).global_position.y), 2))
#		sprite.global_position = Vector2((get_node(node_a).global_position.x + get_node(node_b).global_position.x) / 2, (get_node(node_a).global_position.y + get_node(node_b).global_position.y) / 2)
#		sprite.rotation = (atan2(get_node(node_a).global_position.y - get_node(node_b).global_position.y, get_node(node_a).global_position.x - get_node(node_b).global_position.x))



#start function (called by constructor)
func _init_begin():
	rest_length = contractedLength
	timer.wait_time = contractTime
	timer.start()
	isExpanding = true

#repatedly called after "contract time" and "expand time" seconds have passed
func _on_Timer_timeout():
	#called when the timer runs out of time
	if (!frozen):
		if (isExpanding):
			rest_length = length #expands length
			timer.wait_time = expandTime
			timer.start() #starts the timer to wait "wait_time" seconds
			isExpanding = false
		else:
			rest_length = contractedLength #contracts length
			timer.wait_time = contractTime
			timer.start() #starts the timer to wait "wait_time" seconds
			isExpanding = true

#constructor, function is manually called when a new joint is constructed
func init(contracted_Length, expanded_Length, contract_Time, expand_Time, _stiffness, _damping, _bias, node1 : NodePath, node2: NodePath, startExpand):
	contractedLength = contracted_Length
	contractedLength2 = contracted_Length
	length = expanded_Length
	
	contractTime = contract_Time
	expandTime = expand_Time
	
	stiffness = _stiffness
	damping = _damping
	bias = _bias
	
	node_a = node1
	node_b = node2
	
	
	if stiffness < 5:
		$w.visible = true
		sprite = $w
	elif stiffness < 10:
		$lg.visible = true
		sprite = $lg
	elif stiffness < 15:
		$dg.visible = true
		sprite = $dg
	else:
		$b.visible = true
		sprite = $b
	
	constructed = true
	
	isExpanding = startExpand
	if (!frozen):
		_init_begin()
