extends Reference

# Bleeding entities take extra damage for a few turns
const _BLEEDING_DAMAGE_PERCENT: float = 0.3 # 0.3 => 30% more damage
const _TURNS_INFLICTED: int = 3

var _bleeding_turns_left = {} # entity => turns left

func add_bleeding(target: Resource) -> void:
	if not target in _bleeding_turns_left:
		_bleeding_turns_left[target] = 0
	_bleeding_turns_left[target] += _TURNS_INFLICTED

func on_player_moved(player: Player, old_tile_position: Vector2, new_tile_position: Vector2):
	var to_remove = []
	for victim in _bleeding_turns_left.keys():
		_bleeding_turns_left[victim] -= 1
		if _bleeding_turns_left[victim] <= 0:
			to_remove.append(victim)

	for victim in to_remove:
		_bleeding_turns_left.erase(victim)

# TODO: base class victim (not slime)
func attack_entity(aggressor: Entity, victim: Entity, damage: int) -> int:
	############### TODO: REMOVE, for testing only
	if randf() < 0.25: add_bleeding(victim)
	
	if victim == null:
		return damage

	if not victim in _bleeding_turns_left or _bleeding_turns_left[victim] == 0 or \
	victim.health <= 0:
		return damage

	var bleeding_damage = int(damage * _BLEEDING_DAMAGE_PERCENT)
	return damage + bleeding_damage
