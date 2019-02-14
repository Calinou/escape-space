# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var game := $"/root/Game" as Node
onready var pause_options := $VBoxContainer as Control

func _on_visibility_changed() -> void:
	if visible:
		pause_options.get_child(0).grab_focus()

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
