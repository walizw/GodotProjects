extends Actor

func _physics_process (delta: float) -> void:
	var dir: = get_direction ()
	velocity = dir * speed
	velocity = move_and_slide (velocity)

func get_direction () -> Vector2:
	return Vector2 (
		Input.get_action_strength ("right") - Input.get_action_strength ("left"),
		-1.0 if Input.is_action_just_pressed ("jump") and is_on_floor () else 1.0
	)
