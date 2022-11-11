extends Reference

signal entity_died(entity)

const BleedingSystem = preload("res://contexts/core/scripts/systems/skills/BleedingSystem.gd")

# "Basic," ya3ne, melee and range with no special elementals/effects/etc. applied
const _MINION_CHASE_RANGE = 2

# Order matters
var _damage_filters = [
	BleedingSystem.new()
]

func on_player_moved(player: Player, old_position: Vector2, new_position: Vector2):
	for filter in _damage_filters:
		filter.on_player_moved(player, old_position, new_position)


func on_attack_target(minion: Minion):
	var damage = minion.attack
	print("Attacking for %s damage ..." % damage)

	# Every filter gets a "damage incoming" event (sorta) and can decide how to react or modify it
	for filter in _damage_filters:
		damage = filter.attack_target(minion, damage)
		print("Applied %s, damage=%s" % [filter, damage])

	minion.target.health -= damage

	if minion.target.health <= 0:
		emit_signal("entity_died", minion.target)
		minion.target = null

