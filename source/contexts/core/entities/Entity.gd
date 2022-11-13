class_name Entity

extends Resource

# read only, settable only within the owner script
var name: String setget _set_name, _get_name

var attack: int
var health: int
var tile_position: Vector2

func _set_name(val):
	pass

func _get_name():
	return name


