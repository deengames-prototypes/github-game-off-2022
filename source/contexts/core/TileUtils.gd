class_name TileUtils

static func is_walkable(tile_position: Vector2, _terrain_tile_map: TileMap, all_entities: Array) -> bool:
	var tile_id = _terrain_tile_map.get_cellv(tile_position)
	var tile_name = _terrain_tile_map.tile_set.tile_get_name(tile_id)
	if tile_name == "wall":
		return false
	for e in all_entities:
		if e.tile_position == tile_position:
			return false
	return true

