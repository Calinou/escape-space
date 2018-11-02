# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene("res://game/game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
