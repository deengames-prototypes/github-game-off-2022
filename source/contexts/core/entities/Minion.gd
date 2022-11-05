class_name Minion

extends Resource

enum {FOLLOWING, ATTACKING, IDLE}

var state = FOLLOWING
var health: int = 4
var tile_position: Vector2 = Vector2()
