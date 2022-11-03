extends Node2D

signal move_player(displacement)

onready var _entities_tile_map = $Entities
onready var _terrain_tile_map = $Terrain

var _entities_by_name = {}
var _player: Player = Player.new()

var _player_controller = preload("res://contexts/core/servers/PlayerController.gd").new(_player)
var _input_system = preload("res://contexts/core/servers/InputSystem.gd").new()

func _ready():
	_input_system.connect("try_move_player", self, "on_move_player")
	connect("move_player", _player_controller, "on_move_player")
	_player_controller.connect("player_moved", self, "on_player_moved")

	add_child(_input_system)
	add_child(_player_controller)

	for tile_id in _entities_tile_map.tile_set.get_tiles_ids():
		_entities_by_name[_entities_tile_map.tile_set.tile_get_name(tile_id)] = tile_id

	_player.tile_position = Vector2(3, 7)
	_entities_tile_map.set_cellv(_player.tile_position, _entities_by_name["player"])

func on_player_moved(old: Vector2, new: Vector2):
	_entities_tile_map.set_cellv(old, -1)
	_entities_tile_map.set_cellv(new, _entities_by_name["player"])

func on_move_player(displacement: Vector2):
	if TileUtils.is_walkable(_player.tile_position + displacement, _terrain_tile_map, [_player]):
		emit_signal("move_player", displacement)

