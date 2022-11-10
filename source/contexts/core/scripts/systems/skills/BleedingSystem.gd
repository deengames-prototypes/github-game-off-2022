extends Node

# Bleeding entities take extra damage for a few turns
const _BLEEDING_DAMAGE_PERCENT: float = 0.3 # 0.3 => 30% more damage
const _TURNS_INFLICTED: int = 3

var _bleeding_turns_left = {} # entity => turns left

func add_bleeding(target: Resource) -> void:
	if not target in _bleeding_turns_left:
		_bleeding_turns_left[target] = 0
	_bleeding_turns_left[target] += _TURNS_INFLICTED

func on_player_moved(player, old_tile_position: Vector2, new_tile_position: Vector2):
	var to_remove = []
	for victim in _bleeding_turns_left.keys():
		_bleeding_turns_left[victim] -= 1
		if _bleeding_turns_left[victim] <= 0:
			to_remove.append(victim)
	
	for victim in to_remove:
		_bleeding_turns_left.erase(victim)

# TODO: base class victim (not slime)
func on_attack(victim: Slime, base_damage: int) -> void:
	if victim in _bleeding_turns_left and _bleeding_turns_left[victim] > 0 and \
	victim.health >= 0:
		var bleeding_damage = int(base_damage * _BLEEDING_DAMAGE_PERCENT)
		if bleeding_damage > 0:
			victim.health -= bleeding_damage
			if victim.health <= 0:
				emit_signal("entity_died", victim)
				# Added complexity: minion.target might be null
