# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

func _on_play_pressed() -> void:
	get_tree().change_scene("res://game/game.tscn")

func _on_options_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Options")

func _on_quit_pressed() -> void:
	get_tree().quit()
