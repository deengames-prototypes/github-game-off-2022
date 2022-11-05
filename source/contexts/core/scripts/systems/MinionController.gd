extends Node

signal minion_moved(minion, old_tile_position, new_tile_position)

var _player: Player
var _all_entities: Array
var _terrain_tile_map: TileMap

func _init(player: Player, terrain_tile_map: TileMap, all_entities: Array):
	_player = player
	_terrain_tile_map = terrain_tile_map
	_all_entities = all_entities

func on_player_moved(entity, old_position: Vector2, new_position:Vector2):
	for entity in _all_entities:
		if entity is Minion:
			take_turn(entity)

func take_turn(minion: Minion):
	match minion.state:
		minion.FOLLOWING:
			follow_player(minion)
		minion.ATTACKING:
			pass
		minion.IDLE:
			pass

func follow_player(minion: Minion):
	var direction := minion.tile_position.direction_to(_player.tile_position)

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
