extends KinematicBody2D
class_name Actor

export var speed: = Vector2 (300.0, 1000.0)
export var grav: = 3000.0
var velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += grav * delta
	velocity.y = min (speed.y, velocity.y)
	velocity = move_and_slide (velocity)
