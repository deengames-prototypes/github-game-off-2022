class_name TileUtils

const _UNWALKABLE_TILE_NAMES = ["wall"]

static func is_walkable(terrain_tile_map:TileMap, tile_position:Vector2, all_entities:Array) -> bool:
	var tile_id = terrain_tile_map.get_cellv(tile_position)
	var tile_name = terrain_tile_map.tile_set.tile_get_name(tile_id)
	
	if tile_name in _UNWALKABLE_TILE_NAMES:
		return false
		
	for e in all_entities:
		if e.tile_position == tile_position:
			return false
			
	return true

