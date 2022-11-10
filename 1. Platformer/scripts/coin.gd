extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer


func _on_coin_body_entered(body: Node) -> void:
	anim_player.play ("fade_out")
