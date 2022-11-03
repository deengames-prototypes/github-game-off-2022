extends Node

signal move_player(displacement)

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		emit_signal("move_player", Vector2.UP)
	elif Input.is_action_just_pressed("ui_right"):
		emit_signal("move_player", Vector2.RIGHT)
	elif Input.is_action_just_pressed("ui_down"):
		emit_signal("move_player", Vector2.DOWN)
	elif Input.is_action_just_pressed("ui_left"):
		emit_signal("move_player", Vector2.LEFT)
