extends Node

signal player_moved(old, new)

var _player: Player

func _init(player: Player):
	_player = player

func on_move_player(displacement: Vector2):
	var old = _player.tile_position
	_player.tile_position += displacement
	emit_signal("player_moved", old, _player.tile_position)
