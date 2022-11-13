class_name Minion

extends Entity

enum {FOLLOWING, ATTACKING}

var discover_distance = 5 setget set_noop
var chase_range = 2 setget set_noop
var following_distance = 3 setget set_noop
var retreat_distance = 7 setget set_noop

func set_noop(val):
	pass

var state = FOLLOWING
var target: Entity = null

var skills: Array = []

func _init(x: int, y: int):
	name = 'minion'
	attack = 10
	health = 4
	tile_position = Vector2(x, y)
