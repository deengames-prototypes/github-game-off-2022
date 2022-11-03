extends Node

const InputSystem = preload("res://contexts/core/scripts/systems/InputSystem.gd")

signal player_moved(new_tile_position)

var _input_system = InputSystem.new()
var _player:Player
var _terrain_tile_map:TileMap

func _init(player:Player, terrain_tile_map:TileMap):
	_player = player
	_terrain_tile_map = terrain_tile_map
	_input_system.connect("try_move_player", self, "on_move_player")

func _ready():
	add_child(_input_system)

func on_move_player(displacement:Vector2):
	if displacement.length() > 1:
		push_error("Player moved %s tiles, too far" % displacement.length())
	var old_tile_position = _player.tile_position
	var new_tile_position = old_tile_position + displacement
	
	if TileUtils.is_walkable(_terrain_tile_map, new_tile_position, [_player]):
		emit_signal("player_moved", old_tile_position, new_tile_position)

