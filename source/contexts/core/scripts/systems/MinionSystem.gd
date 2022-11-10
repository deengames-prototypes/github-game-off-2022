extends Node

const ENEMY_DISCOVER_DISTANCE = 5
const _CHASE_RANGE = 2
const FOLLOWING_DISTANCE = 3
const RETREAT_DISTANCE = 7

signal attack_target(minion, target)
signal chase_entity(minion, target)
signal entity_died(entity)
signal minion_attacks_entity(minion, entity)
signal bleed(victim)

var _player: Player
var _all_entities: Array
var _terrain_tile_map: TileMap

func _init(player: Player, terrain_tile_map: TileMap, all_entities: Array):
	_player = player
	_terrain_tile_map = terrain_tile_map
	_all_entities = all_entities

func on_player_moved(entity, old_position: Vector2, new_position: Vector2):
	for entity in _all_entities:
		if entity is Minion:
			take_turn(entity)

func take_turn(minion: Minion):
	match minion.state:
		minion.FOLLOWING:
			for enemy in get_enemies_near(minion):
				if is_near_player(enemy):
					minion.state = minion.ATTACKING
					minion.target = enemy
		minion.ATTACKING:
			if minion.target == null:
				minion.state = minion.FOLLOWING


	match minion.state:
		minion.FOLLOWING:
			if minion.tile_position.distance_to(_player.tile_position) >= FOLLOWING_DISTANCE:
				emit_signal("chase_entity", minion, _player)
		minion.ATTACKING:
			if minion.tile_position.distance_to(_player.tile_position) >= RETREAT_DISTANCE:
				minion.state = minion.FOLLOWING
			else:
				self.try_to_attack_target(minion)

# attacking

func get_enemies_near(minion):
	# TODO: this call is expensive (computationally and algorithmically)
	var ls := []
	for entity in _all_entities:
		if entity is Slime and entity.tile_position.distance_to(minion.tile_position) <= ENEMY_DISCOVER_DISTANCE:
			ls.append(entity)
	return ls

func is_near_player(enemy):
	return enemy.tile_position.distance_to(_player.tile_position) <= ENEMY_DISCOVER_DISTANCE

func try_to_attack_target(minion):
	if minion.target.health <= 0:
		minion.target = null
		return

	if minion.tile_position.distance_to(minion.target.tile_position) > _CHASE_RANGE:
		emit_signal("chase_entity", minion, minion.target)
	else:
		############### TODO: REMOVE, for testing only
		if randf() < 0.5: emit_signal("bleed", minion.target)

		emit_signal("attack_target", minion)
