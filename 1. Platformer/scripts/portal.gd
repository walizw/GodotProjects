tool
extends Area2D

export var next_scene: PackedScene
onready var anim_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered (body: Node) -> void:
	teleport ()

func _get_configuration_warning () -> String:
	return "The next scene property can't be empty" if not next_scene else ""

func teleport () -> void:
	anim_player.play ("fade_in")
	yield (anim_player, "animation_finished") # waits for a signal to be emitted
	
	# change the scene
	get_tree ().change_scene_to (next_scene)
