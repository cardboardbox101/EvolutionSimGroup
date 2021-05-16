extends DampedSpringJoint2D

var isExpanding = false

func _ready():
	if (isExpanding):
		rest_length = 50
		$Timer.wait_time = 2
		$Timer.start()
		isExpanding = false
	else:
		rest_length = 5
		$Timer.wait_time = 2
		$Timer.start()
		isExpanding = true

func _on_Timer_timeout():
	if (isExpanding):
		rest_length = 50
		$Timer.wait_time = 2
		$Timer.start()
		isExpanding = false
	else:
		rest_length = 5
		$Timer.wait_time = 2
		$Timer.start()
		isExpanding = true
