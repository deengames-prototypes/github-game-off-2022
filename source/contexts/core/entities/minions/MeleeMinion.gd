class_name MeleeMinion

extends Minion

func _init(x: int, y: int):
	name = 'minion'
	attack = 10
	health = 4
	tile_position = Vector2(x, y)

	discover_distance = 5
	chase_range = 2
	following_distance = 3
	retreat_distance = 7

