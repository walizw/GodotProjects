extends Actor

export var stomp_impulse: = 1000.0

func _on_StompDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity (_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: Node) -> void:
	queue_free ()

func _physics_process (delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released ("jump") and _velocity.y < 0.0
	var dir: = get_direction ()
	_velocity = calculate_mov_velocity (_velocity, speed, dir, is_jump_interrupted)
	var snap: = Vector2.DOWN * 85.0 if dir.y == 0 else Vector2.ZERO
	_velocity.y = move_and_slide_with_snap (
		_velocity, snap, FLOOR_NORMAL, true, 4, PI / 3.0
	).y

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
	var out = linear_velocity
	out.x = speed.x * dir.x
	out.y += grav * get_physics_process_delta_time ()
	if dir.y == -1.0:
		out.y = speed.y * dir.y
	
	if jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity (
		linear_velocity: Vector2,
		impulse: float
	) -> Vector2:
	var out := linear_velocity
	out.y = -impulse
	return out

