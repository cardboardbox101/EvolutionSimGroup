extends RigidBody2D

var originalPos = Vector2()

func set_color():
	$lr.visible = false
	$mr.visible = false
	$r.visible = false
	$dr.visible = false
	
	if friction < 0.25:
		$lr.visible = true
	elif friction < 0.5:
		$mr.visible = true
	elif friction < 0.75:
		$r.visible = true
	else:
		$dr.visible = true
