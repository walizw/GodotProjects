extends Node

# The track's beat per minute
export var bpm: = 124

var _bps:  = 60.0 / bpm # beats per second
var _hbps: = _bps * 0.5 # half beats per second

# last half-beat we passed
var _last_half_beat: = 0

onready var _stream: = $AudioStreamPlayer2D

func _ready () -> void:
	play_audio ()

func _process (delta: float) -> void:
	var time: float = (
		_stream.get_playback_position () +
		AudioServer.get_time_since_last_mix () -
		AudioServer.get_output_latency ()
	)
	
	# calculate the current half beat
	var half_beat: = int (time / _hbps)
	
	if half_beat > _last_half_beat:
		_last_half_beat = half_beat

func play_audio () -> void:
	var time_delay: = AudioServer.get_time_to_next_mix () + AudioServer.get_output_latency ()
	yield (get_tree ().create_timer (time_delay), "timeout")
	
	_stream.play ()
