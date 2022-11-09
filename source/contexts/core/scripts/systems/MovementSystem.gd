extends Node

signal entity_moved(entity, old_tile_position, new_tile_position)

var _all_entities: Array
var _terrain_tile_map: TileMap

func _init(terrain_tile_map: TileMap, all_entities: Array):
	_terrain_tile_map = terrain_tile_map
	_all_entities = all_entities

func on_chase_entity(entity, target):
	var direction: Vector2 = entity.tile_position.direction_to(target.tile_position)

	var displacement: Vector2
	var aspect := abs(direction.aspect())

	if direction.x >= 0 and direction.y < 0:
		displacement = Vector2.RIGHT if aspect >= 1 else Vector2.UP
	elif direction.x >= 0 and direction.y >= 0:
		displacement = Vector2.RIGHT if aspect >= 1 else Vector2.DOWN
	elif direction.x < 0 and direction.y >= 0:
		displacement = Vector2.LEFT if aspect >= 1 else Vector2.DOWN
	else: # direction.x < 0 and direction.y < 0
		displacement = Vector2.LEFT if aspect >= 1 else Vector2.UP

	move_entity(entity, displacement)

func move_entity(entity, displacement: Vector2):
	if displacement.length() > 1:
		push_error("%s moved %s tiles, too far" % [entity.name, displacement.length()])
	var old_tile_position = entity.tile_position
	var new_tile_position = old_tile_position + displacement

	if MovementCheck.is_walkable(_terrain_tile_map, new_tile_position, _all_entities):
		emit_signal("entity_moved", entity, old_tile_position, new_tile_position)
