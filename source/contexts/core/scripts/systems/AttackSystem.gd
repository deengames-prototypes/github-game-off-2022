extends Reference

signal entity_died(entity)

const BleedingSystem = preload("res://contexts/core/scripts/systems/skills/BleedingSystem.gd")

# Order matters
var _damage_filters = [
	BleedingSystem.new()
]

func on_player_moved(player: Player, old_position: Vector2, new_position: Vector2):
	for filter in _damage_filters:
		filter.on_player_moved(player, old_position, new_position)


func on_attack_entity(aggressor: Entity, victim: Entity):
	var damage = aggressor.attack
	print("Attacking for %s damage ..." % damage)

	# Every filter gets a "damage incoming" event (sorta) and can decide how to react or modify it
	for filter in _damage_filters:
		damage = filter.attack_entity(aggressor, victim, damage)
		print("Applied %s, damage=%s" % [filter, damage])

	victim.health -= damage

	if victim.health <= 0:
		emit_signal("entity_died", victim)

