extends Node2D

const BasicAttackSystem = preload("res://contexts/core/scripts/systems/BasicAttackSystem.gd")
const BleedingSystem = preload("res://contexts/core/scripts/systems/skills/BleedingSystem.gd")
const MinionSystem = preload("res://contexts/core/scripts/systems/MinionSystem.gd")
const MovementSystem = preload("res://contexts/core/scripts/systems/MovementSystem.gd")
const PlayerController = preload("res://contexts/core/scripts/systems/PlayerController.gd")

onready var _entities_tile_map = $Entities
onready var _terrain_tile_map = $Terrain

onready var _player_controller = PlayerController.new(_player, _terrain_tile_map, _entities)
onready var _minion_system = MinionSystem.new(_player, _terrain_tile_map, _entities)
onready var _movement_system = MovementSystem.new(_terrain_tile_map, _entities)

# This ... is starting to get messy
var _attack_system = BasicAttackSystem.new()
var _bleeding_system = BleedingSystem.new()

var _player:Player = Player.new()
var _entities:Array = [_player]

func _ready():
	_wire_up_signals()

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

func _wire_up_signals():
	# Player controller
	_player_controller.connect("player_moved", _bleeding_system, "on_player_moved")
	_player_controller.connect("player_moved", _entities_tile_map, "on_entity_moved")
	_player_controller.connect("player_moved", _minion_system, "on_player_moved")
	add_child(_player_controller)

	# Movement system
	_movement_system.connect("entity_moved", _entities_tile_map, "on_entity_moved")
	_minion_system.connect("chase_entity", _movement_system, "on_chase_entity")
	add_child(_movement_system)

	# Minion system
	_minion_system.connect("entity_died", self, "on_entity_died")
	_minion_system.connect("attack_target", _attack_system, "attack_target")
	_minion_system.connect("bleed", _bleeding_system, "add_bleeding")
	add_child(_minion_system);
	
	# Attack system
	_attack_system.connect("on_attack", _bleeding_system, "on_attack")
