class_name Minion

extends Entity

enum {FOLLOWING, ATTACKING}

var discover_distance = 5 setget _set_noop
var chase_range = 2 setget _set_noop
var following_distance = 3 setget _set_noop
var retreat_distance = 7 setget _set_noop

func _set_noop(val):
	pass

var state = FOLLOWING
var target: Entity = null
