extends Node

# "Basic," ya3ne, melee and range with no special elementals/effects/etc. applied
const _MINION_CHASE_RANGE = 2

signal on_attack(victim, base_damage)

func on_player_moved(player: Player, old_tile_position: Vector2, new_tile_position: Vector2):
	pass # unused

func attack_target(minion: Minion, damage: int) -> int:
	return minion.attack
