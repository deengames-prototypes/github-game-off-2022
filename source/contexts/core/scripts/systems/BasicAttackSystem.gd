extends Node

# "Basic," ya3ne, melee and range with no special elementals/effects/etc. applied
const _MINION_CHASE_RANGE = 2

func attack_target(minion: Minion):
	minion.target.health -= minion.attack
	if minion.target.health <= 0:
		emit_signal("entity_died", minion.target)
		minion.target = null
