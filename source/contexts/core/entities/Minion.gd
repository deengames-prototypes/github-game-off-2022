class_name Minion

extends Resource

const name := 'minion'
enum {FOLLOWING, ATTACKING, IDLE}

var state = FOLLOWING
var target = null

var attack: int = 10
var health: int = 4
var tile_position: Vector2 = Vector2()
