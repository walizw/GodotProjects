extends Node2D

var order_number: = 0 setget set_order_number

var _beat_hit: = false # true if player already tapped

onready var _anim_player: = $AnimationPlayer
onready var _sprite: = $Sprite
onready var _touch_area: = $Area2D
onready var _label: = $Label

func _ready () -> void:
	_anim_player.play ("show")

func setup (data: Dictionary) -> void:
	self.order_number = data.half_beat
	global_position = data.global_position
	_sprite.frame = data.color

func set_order_number (number: int) -> void:
	order_number = number
	_label.text = str (order_number)


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed ("touch"):
		_beat_hit = true
		
		# We disable any further events by removing any physics layers
		_touch_area.collision_layer = 0
		_anim_player.play ("destroy")
