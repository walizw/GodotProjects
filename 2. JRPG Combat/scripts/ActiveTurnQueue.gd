# Queues and delegates turns for all battlers
extends Node2D
class_name ActiveTurnQueue

var _party_members: = []
var _opponents: = []

# Allows pausing the active time battle during combat intro, a cutscene or
# combat end
var is_active: = true setget set_is_active

# Multiplier for the global pace of battle, to slow down time while the player
# is making decisions. This is meant for accessibility and to control difficulty
var time_scale: = 1.0 setget set_time_scale

# All battlers in the encounter are children of this node. We can get a list of
# them with `get_children'
onready var battlers: = get_children ()

func _ready() -> void:
	for battler in battlers:
		# Listen to each battler's ready to act signal, binding a reference to
		# the battler to the callback.
		battler.connect ("ready_to_act", self, "_on_Battler_ready_to_act", [battler])
		if battler.is_party_member:
			_party_members.append (battler)
		else:
			_opponents.append (battler)

func _on_Battler_ready_to_act (battler: Battler) -> void:
	_play_turn (battler)

func _play_turn (battler: Battler) -> void:
	var action_data: ActionData
	var targets: = []
	
	battler.stats.energy += 1
	
	# The code below makes a list of selectable targets using `Battler.is_selectable'
	var potential_targets: = []
	var opponents: = _opponents if battler.is_party_member else _party_members
	for opponent in opponents:
		if opponent.is_selectable:
			potential_targets.append (opponent)
	
	if battler.is_player_controlled ():
		battler.is_selected = true
		self.time_scale = 0.05
		
		var is_selection_complete: = false
		while not is_selection_complete:
			action_data = yield (_player_select_action_async (battler), "completed")
			
			if action_data.is_targeting_self:
				targets = [battler]
			else:
				targets = yield (
					_player_select_targets_async (action_data, potential_targets),
					"completed"
				)
			
			is_selection_complete = action_data != null && targets != []
		
		# Reset the time scale and deselect the battler
		set_time_scale (1.0)
		battler.is_selected = false
	else:
		action_data = battler.actions [0]
		targets = [potential_targets [0]]

func _player_select_action_async (battler: Battler) -> ActionData:
	yield (get_tree (), "idle_frame")
	return battler.actions [0]

func _player_select_targets_async (_action: ActionData, opponents: Array) -> Array:
	yield (get_tree (), "idle_frame")
	return [opponents [0]]

# Updates `is_active' on each battler
func set_is_active (val: bool) -> void:
	is_active = val
	for battler in battlers:
		battler.is_active = is_active

# Updates `time_scale' on each battler
func set_time_scale (val: float) -> void:
	time_scale = val
	for battler in battlers:
		battler.time_scale = time_scale
