extends Node2D

const PlayerController = preload("res://contexts/core/servers/PlayerController.gd")

onready var _entities_tile_map = $Entities
onready var _terrain_tile_map = $Terrain

onready var _player_controller = PlayerController.new(_player, _terrain_tile_map)

var _entities_by_name = {}
var _player:Player = Player.new()

func _ready():
	_player_controller.connect("player_moved", self, "on_player_moved")
	add_child(_player_controller)

	for tile_id in _entities_tile_map.tile_set.get_tiles_ids():
		_entities_by_name[_entities_tile_map.tile_set.tile_get_name(tile_id)] = tile_id

	_player.tile_position = Vector2(9, 8)
	_entities_tile_map.set_cellv(_player.tile_position, _entities_by_name["player"])

func on_player_moved(old_tile_position: Vector2, new_tile_position: Vector2):
	_player.tile_position = new_tile_position
	_entities_tile_map.set_cellv(old_tile_position, TileMap.INVALID_CELL)
	_entities_tile_map.set_cellv(new_tile_position, _entities_by_name["player"])
