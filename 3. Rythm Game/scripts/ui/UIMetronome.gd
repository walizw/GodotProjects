extends Sprite

var _start_scale: = Vector2.ONE * 1.5
var _end_scale: = Vector2.ONE

onready var _tween: = $Tween

func _ready ():
	EventBus.connect ("beat_incremented", self, "_pulse")

func _pulse (msg: Dictionary):
	# Pulse only every beat
	if msg.half_beat % 2 == 1:
		return
	
	var _beats_per_second: float = msg.bps
	
	_tween.interpolate_property (
		self,
		"scale",
		_start_scale,
		_end_scale,
		_beats_per_second / 4,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	_tween.start ()
