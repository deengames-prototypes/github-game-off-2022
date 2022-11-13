extends Node



signal chase_entity(minion, target)
signal attack_entity(minion, target)

var _player: Player
var _all_entities: Array
var _terrain_tile_map: TileMap

func _init(player: Player, terrain_tile_map: TileMap, all_entities: Array):
	_player = player
	_terrain_tile_map = terrain_tile_map
	_all_entities = all_entities

func on_player_moved(entity: Entity, old_position: Vector2, new_position: Vector2):
	for entity in _all_entities:
		if entity is Minion:
			take_turn(entity)

func on_entity_died(deceased: Entity):
	for entity in _all_entities:
		if entity is Minion and entity.target == deceased:
			entity.target = null

func take_turn(minion: Minion):
	match minion.state:
		minion.FOLLOWING:
			for enemy in get_enemies_near(minion):
				if is_near_player(minion, enemy):
					minion.state = minion.ATTACKING
					minion.target = enemy
		minion.ATTACKING:
			if (minion.target == null
			or minion.tile_position.distance_to(_player.tile_position) >= minion.retreat_distance):
				minion.state = minion.FOLLOWING


	match minion.state:
		minion.FOLLOWING:
			if minion.tile_position.distance_to(_player.tile_position) >= minion.following_distance:
				emit_signal("chase_entity", minion, _player)
		minion.ATTACKING:
			self.try_to_attack_target(minion)

# attacking

func get_enemies_near(minion: Minion):
	# TODO: this call is expensive (computationally and algorithmically)
	var ls := []
	for entity in _all_entities:
		if entity is Slime and entity.tile_position.distance_to(minion.tile_position) <= minion.discover_distance:
			ls.append(entity)
	return ls

func is_near_player(minion: Minion, enemy: Entity):
	return enemy.tile_position.distance_to(_player.tile_position) <= minion.discover_distance

func try_to_attack_target(minion: Minion):
	if minion.tile_position.distance_to(minion.target.tile_position) > minion.chase_range:
		emit_signal("chase_entity", minion, minion.target)
	else:
		emit_signal("attack_entity", minion, minion.target)
