extends Node

# creates signals
signal score_updated
signal player_died

var score: = 0 setget set_score
var deaths: = 0 setget set_deaths

func reset () -> void:
	score = 0
	deaths = 0

func set_score (val: int) -> void:
	score = val
	emit_signal ("score_updated")

func set_deaths (val: int) -> void:
	deaths = val
	emit_signal ("player_died")
