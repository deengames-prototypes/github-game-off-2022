class_name Minion

extends Entity

enum {FOLLOWING, ATTACKING}

var state = FOLLOWING
var target: Entity = null

func _init(x: int, y: int):
	name = 'minion'
	attack = 10
	health = 4
	tile_position = Vector2(x, y)
