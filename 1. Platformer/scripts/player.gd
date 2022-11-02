extends Actor

func _physics_process (delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released ("jump") and velocity.y < 0.0
	var dir: = get_direction ()
	velocity = calculate_mov_velocity (velocity, speed, dir, is_jump_interrupted)
	velocity = move_and_slide (velocity, FLOOR_NORMAL)

func get_direction () -> Vector2:
	return Vector2 (
		Input.get_action_strength ("right") - Input.get_action_strength ("left"),
		-1.0 if Input.is_action_just_pressed ("jump") and is_on_floor () else 1.0
	)

func calculate_mov_velocity (
		linear_velocity: Vector2,
		speed: Vector2,
		dir: Vector2,
		jump_interrupted: bool
	) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * dir.x
	new_velocity.y += grav * get_physics_process_delta_time ()
	if dir.y == -1.0:
		new_velocity.y = speed.y * dir.y
	
	if jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity
