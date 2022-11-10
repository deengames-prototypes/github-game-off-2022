extends Node

# "Basic," ya3ne, melee and range with no special elementals/effects/etc. applied
const _MINION_CHASE_RANGE = 2

signal on_attack(victim, base_damage)

func attack_target(minion: Minion):
	var damage: int = minion.attack
	
	if damage > 0:
		minion.target.health -= damage
		emit_signal("on_attack", minion.target, damage)
		# Added complexity: race condition here. Bleeding many not kill the minion before the
		# execution of the next line of code. So we have to duplicate it + add more logic elsewhere
		# to check if minions are dead.
		if minion.target.health <= 0:
			emit_signal("entity_died", minion.target)
			minion.target = null
