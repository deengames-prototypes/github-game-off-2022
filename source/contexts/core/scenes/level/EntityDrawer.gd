extends TileMap

var entities_by_name: Dictionary = {}

func _ready():
	# cache tile ids by name
	for tile_id in tile_set.get_tiles_ids():
		entities_by_name[tile_set.tile_get_name(tile_id)] = tile_id

func draw_entities(entities: Array):
	for entity in entities:
		set_cellv(entity.tile_position, entities_by_name[entity.name])

func on_entity_moved(entity: Entity, old_tile_position: Vector2, new_tile_position: Vector2):
	entity.tile_position = new_tile_position
	set_cellv(old_tile_position, TileMap.INVALID_CELL)
	set_cellv(new_tile_position, entities_by_name[entity.name])

func on_entity_died(entity: Entity):
	set_cellv(entity.tile_position, TileMap.INVALID_CELL)
