extends Actor

func _physics_process (delta: float) -> void:
	var dir: = Vector2 (
		Input.get_action_strength ("right") - Input.get_action_strength ("left"),
		1.0
	)
	
	velocity = dir * speed
	velocity = move_and_slide (velocity)
