extends Node2D

const PlayerController = preload("res://contexts/core/scripts/systems/PlayerController.gd")
const MinionSystem = preload("res://contexts/core/scripts/systems/MinionSystem.gd")
const MovementSystem = preload("res://contexts/core/scripts/systems/MovementSystem.gd")

onready var _entities_tile_map = $Entities
onready var _terrain_tile_map = $Terrain

onready var _player_controller = PlayerController.new(_player, _terrain_tile_map, _entities)
onready var _minion_system = MinionSystem.new(_player, _terrain_tile_map, _entities)
onready var _movement_system = MovementSystem.new(_terrain_tile_map, _entities)

var _player:Player = Player.new()
var _entities:Array = [_player]

func _ready():
	# Wire up signals
	_player_controller.connect("player_moved", _entities_tile_map, "on_entity_moved")
	add_child(_player_controller)

	_movement_system.connect("entity_moved", _entities_tile_map, "on_entity_moved")
	add_child(_movement_system)

	_player_controller.connect("player_moved", _minion_system, "on_player_moved")

	_minion_system.connect("chase_entity", _movement_system, "on_chase_entity")
	_minion_system.connect("entity_died", self, "on_entity_died")
	add_child(_minion_system);

	_player.tile_position = Vector2(9, 8)

	# Generate some slimes to kill
	for i in range(4):
		var slime = Slime.new()
		slime.tile_position = Vector2(11, 8 + i)
		_entities.append(slime)

	# Add the first (test) minion to follow the player around
	var minion = Minion.new()
	minion.tile_position = Vector2(8, 8)
	_entities.append(minion)

	_entities_tile_map.draw_entities(_entities)

func on_entity_died(entity):
	_entities.erase(entity)
	_entities_tile_map.on_entity_died(entity)

