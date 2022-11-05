extends Node

const InputSystem = preload("res://contexts/core/scripts/systems/InputSystem.gd")

signal player_moved(player, old_tile_position, new_tile_position)

var _input_system = InputSystem.new()
var _player:Player
# Arrays are passed by reference in GDScript. As such, this variable is always up to date
var _all_entities:Array
var _terrain_tile_map:TileMap

func _init(player:Player, terrain_tile_map:TileMap, all_entities:Array):
	_player = player
	_terrain_tile_map = terrain_tile_map
	_all_entities = all_entities
	_input_system.connect("try_move_player", self, "on_move_player")

func _ready():
	add_child(_input_system)

func on_move_player(displacement:Vector2):
	if displacement.length() > 1:
		push_error("Player moved %s tiles, too far" % displacement.length())
	var old_tile_position = _player.tile_position
	var new_tile_position = old_tile_position + displacement

	if MovementCheck.is_walkable(_terrain_tile_map, new_tile_position, _all_entities):
		emit_signal("player_moved", _player, old_tile_position, new_tile_position)

