extends KinematicBody2D
class_name Actor

func _physics_process(delta: float) -> void:
	# executed every frame (30/60 times a sec)
	var velocity: = Vector2 (300, 0)
	move_and_slide (velocity)
