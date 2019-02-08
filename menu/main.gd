# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

func _on_play_pressed() -> void:
	emit_signal("menu_changed")
	Music.fade_out()

	yield($"/root/Menu", "transition_finished")
	var error := get_tree().change_scene("res://game/game.tscn")

	if error != OK:
		push_error("Couldn't load the game scene.")

func _on_options_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Options")

func _on_quit_pressed() -> void:
	emit_signal("menu_changed")
	Music.fade_out()

	yield($"/root/Menu", "transition_finished")
	get_tree().quit()

func _on_credits_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Credits")
