class_name RangedMinion

extends Minion

func _init(x: int, y: int):
	name = 'minion'
	attack = 10
	health = 4
	tile_position = Vector2(x, y)
	
	discover_distance = 8
	chase_range = 6
	following_distance = 4
	retreat_distance = 6
