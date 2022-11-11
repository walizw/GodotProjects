extends Actor

func _ready() -> void:
	set_physics_process(false) # deactivate physics_process at the start
	_velocity.x = -speed.x

func _on_StompDetector_body_entered(body: KinematicBody2D) -> void:
	if body.global_position.y > $StompDetector.global_position.y:
		return
	
	$CollisionShape2D.disabled = true # disable the "CollisionShape2D"
	queue_free ()

func _physics_process(delta: float) -> void:
	_velocity.y += grav * delta
	
	if is_on_wall ():
		# change direction
		_velocity.x *= -1.0
	
	var snap: = Vector2.DOWN * 50
	_velocity.y = move_and_slide_with_snap (_velocity, snap, FLOOR_NORMAL).y
