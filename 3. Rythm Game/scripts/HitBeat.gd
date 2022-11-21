extends Node2D

var order_number: = 0 setget set_order_number

var _beat_hit: = false # true if player already tapped

onready var _anim_player: = $AnimationPlayer
onready var _sprite: = $Sprite
onready var _touch_area: = $Area2D
onready var _label: = $Label

# Score awarded for each area
var _score_perfect: = 10
var _score_great: = 5
var _score_ok: = 3

# for the animated ring
var _radius_start: = 150.0
var _radius_perfect: = 70.0
var _radius: = _radius_start # current radius

# scoring areas
var _offset_perfect: = 4
var _offset_great: = 8
var _offset_ok: = 16

# duration (in beats) for the target circle to shrink down to `_radius_perfect'
var _beat_delay: = 4.0

var _speed: = 0.0

func _ready () -> void:
	_anim_player.play ("show")

func _process (delta: float) -> void:
	if _beat_hit:
		return
	
	_radius -= delta * (_radius_start - _radius_perfect) * _speed
	
	if _radius <= _radius_perfect - _offset_perfect:
		_touch_area.collision_layer = 0 # stop taking input
		
		EventBus.emit_signal ("scored", {"score": _get_score (), "position": global_position})
		_anim_player.play ("destroy")
		
		_beat_hit = true

func _get_score () -> int:
	if abs (_radius_perfect - _radius) < _offset_perfect:
		return _score_perfect
	elif abs (_radius_perfect - _radius) < _offset_great:
		return _score_great
	elif abs (_radius_perfect - _radius) < _offset_ok:
		return _score_ok
	return 0

func setup (data: Dictionary) -> void:
	self.order_number = data.half_beat
	global_position = data.global_position
	_sprite.frame = data.color
	
	# set the speed
	_speed = 1.0 / data.bps / _beat_delay

func set_order_number (number: int) -> void:
	order_number = number
	_label.text = str (order_number)

func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed ("touch"):
		_beat_hit = true
		
		# We disable any further events by removing any physics layers
		_touch_area.collision_layer = 0
		_anim_player.play ("destroy")
