class_name Player

extends Entity

func _init(x: int, y: int):
	name = 'player'
	health = 10
	tile_position = Vector2(x, y)
