extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer

export var score: = 10

func _on_coin_body_entered(body: Node) -> void:
	picked ()

func picked () -> void:
	PlayerData.score += score
	anim_player.play ("fade_out")
