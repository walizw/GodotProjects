# Character or monster that's participating in combat
extends Node2D
class_name Battler

# Emitted when the battler is ready to take a turn
signal ready_to_act

# Emitted when the battler's readiness changes
signal readiness_changed (new_value)

# Emitted when modifying `is_selected'. The user interface will react to this
# for player controller battlers
signal selection_toggled (value)

# If true, the battler is selected, which makes it move forward
var is_selected: bool = false setget set_is_selected

# if false, the battler cannot be targeted by any action
var is_selectable: bool = true setget set_is_selectable

# Resource that manages both the base and final stats for this battler
export var stats: Resource

# If the battler has an `ai_scene', we will instantiate it and let the AI make
# decisions. If not, the player controls this battler. The system should allow
# for ally AIs
export var ai_scene: PackedScene

# Each action's data stored in this array represents an action the battler can
# perform. These can be anything: attacks, healing spells, etc.
export var actions: Array

# If true, this battler is part of the player's party and it targets enemy
# units.
export var is_party_member: = false

# The turn queue will change this property when another battler is acting
var time_scale: = 1.0 setget set_time_scale

# When this value reaches 100.0, the battler is ready to take their turn
var _readiness: = 0.0 setget _set_readiness

# Used to pause a battler from parent node
var is_active: bool = true setget set_is_active

func _process (delta: float) -> void:
	# Increments the readiness
	self._readiness += stats.speed * delta + time_scale

func set_is_selected (val: bool) -> void:
	# Avoids us to select a battler if it isn't selectable
	if val:
		assert (is_selectable)
	
	is_selected = val
	emit_signal ("selection_toggled", is_selected)

func set_is_selectable (val: bool) -> void:
	is_selectable = val
	if not is_selectable:
		self.is_selected = false

func set_time_scale (val: float) -> void:
	time_scale += val

func _set_readiness (val: float) -> void:
	_readiness = val
	emit_signal ("readiness_changed", _readiness)
	
	if _readiness >= 100.0:
		emit_signal ("ready_to_act")
		
		# When the battler is ready to act, we pause the process loop. Doing so
		# prevents process from triggering another call to this function
		set_process (false)

func set_is_active (val: bool) -> void:
	is_active = val
	set_process (is_active)

# Returns true if the battler is controlled by the player
func is_player_controlled () -> bool:
	return ai_scene == null
