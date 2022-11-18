# Stores and manages the battler's base stats like health, energy and base
# damage
extends Node
class_name BattlerStats

# Emitted when a character has no `health' left
signal health_depleted

# Emitted everytime the value of `health' changes, we will use it to animate
# the life bar
signal health_changed (old_val, new_val)

# Same as above, but for the energy
signal energy_changed (old_val, new_val)

export var max_health: = 100.0
export var max_energy: = 6

var health: = max_health setget set_health
var energy: = 0 setget set_energy

export var base_attack: = 10.0 setget set_base_attack
export var base_defense: = 10.0 setget set_base_defense
export var base_speed: = 70.0 setget set_base_speed
export var base_hit_chance: = 100.0 setget set_base_hit_chance
export var base_evasion: = 0.0 setget set_base_evasion

# These variables are meant to be used read-only
var attack: = base_attack setget , get_attack
var defense: = base_defense setget , get_defense
var speed: = base_speed setget , get_speed
var hit_chance: = base_hit_chance setget , get_hit_chance
var evasion: = base_evasion setget , get_evasion

func get_attack () -> float:
	return attack

func get_defense () -> float:
	return defense

func get_speed () -> float:
	return speed

func get_hit_chance () -> float:
	return hit_chance

func get_evasion () -> float:
	return evasion

func reinitialize () -> void:
	self.health = max_health

func set_base_attack (val: float) -> void:
	base_attack = val
	_recalculate_and_update ("attack")

func set_base_defense (val: float) -> void:
	base_defense = val
	_recalculate_and_update ("defense")

func set_base_speed (val: float) -> void:
	base_speed = val
	_recalculate_and_update ("speed")

func set_base_hit_chance (val: float) -> void:
	base_hit_chance = val
	_recalculate_and_update ("hit_chance")

func set_base_evasion (val: float) -> void:
	base_evasion = val
	_recalculate_and_update ("evasion")

func set_health (val: float) -> void:
	var prev: = health
	health = clamp (val, 0.0, max_health)
	emit_signal ("health_changed", prev, health)
	
	# As we are workign with decimal values, using the `==' operator for
	# comparisons isn't safe. Instead, we need to call `is_equal_approx'
	if is_equal_approx (health, 0.0):
		emit_signal ("health_depleted")

func set_energy (val: int) -> void:
	var prev: = energy
	energy = int (clamp (val, 0.0, max_energy))
	emit_signal ("energy_changed", prev, energy)

func _recalculate_and_update (stat: String) -> void:
	pass
