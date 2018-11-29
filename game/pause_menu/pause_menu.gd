# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var game := $"/root/Game" as Node

func _on_continue_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_restart_level_pressed() -> void:
	get_tree().paused = false
	visible = false
	game.change_level(game.current_level)

func _on_exit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://menu/menu.tscn")
