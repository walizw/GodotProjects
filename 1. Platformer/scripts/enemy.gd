extends Actor

func _ready() -> void:
	set_physics_process(false) # deactivate physics_process at the start
	_velocity.x = -speed.x

func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y > get_node ("StompDetector").global_position.y:
		return
	
	get_node ("CollisionShape2D").disabled = true # disable the "CollisionShape2D"
	queue_free ()

func _physics_process(delta: float) -> void:
	_velocity.y += grav * delta
	
	if is_on_wall ():
		# change direction
		_velocity.x *= -1.0
	
	_velocity.y = move_and_slide (_velocity, FLOOR_NORMAL).y
