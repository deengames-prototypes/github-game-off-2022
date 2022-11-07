extends Node

const ENEMY_DISCOVER_DISTANCE = 5
const ATTACK_DISTANCE = 2

signal minion_moved(minion, old_tile_position, new_tile_position)

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

	match minion.state:
		minion.FOLLOWING:
			follow_player(minion)
		minion.ATTACKING:
			attack_target(minion)
		minion.IDLE:
			pass

# movement

func follow_player(minion: Minion):
	chase_entity(minion, _player)

func chase_entity(minion: Minion, entity):
	var direction := minion.tile_position.direction_to(entity.tile_position)

	var displacement: Vector2
	if direction.aspect() > 0.5:
		displacement = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	else:
		displacement = Vector2.UP if direction.y < 0 else Vector2.DOWN

	move_minion(minion, displacement)

func move_minion(minion: Minion, displacement: Vector2):
	if displacement.length() > 1:
		push_error("Minion moved %s tiles, too far" % displacement.length())
	var old_tile_position = minion.tile_position
	var new_tile_position = old_tile_position + displacement

	if MovementCheck.is_walkable(_terrain_tile_map, new_tile_position, _all_entities):
		emit_signal("minion_moved", minion, old_tile_position, new_tile_position)

# attacking

func get_enemies_near(minion):
	var ls := []
	for entity in _all_entities:
		if entity is Slime and entity.tile_position.distance_to(minion.tile_position) <= ENEMY_DISCOVER_DISTANCE:
			ls.append(entity)
	return ls

func is_near_player(enemy):
	return enemy.tile_position.distance_to(_player.tile_position) <= ENEMY_DISCOVER_DISTANCE

func attack_target(minion):
	if minion.tile_position.distance_to(minion.target.tile_position) > ATTACK_DISTANCE:
		chase_entity(minion, minion.target)
	else:
		# TODO: move into own system
		minion.target.health -= minion.attack
		print(minion.target.name, minion.target.health)
		if minion.target.health <= 0:
			minion.target = null
			minion.state = minion.FOLLOWING
