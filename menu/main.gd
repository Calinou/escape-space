# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

onready var version_label := $Version as Label


func start_game() -> void:
	var error := get_tree().change_scene("res://game/game.tscn")

	if error != OK:
		push_error("Couldn't load the game scene.")


func _ready() -> void:
	version_label.text = ProjectSettings.get_setting("application/config/version")
	
	# Start the game immediately if `--level=N` is passed on the command line
	# Setting the starting level is handled in `game/game.gd`
	if CommandLine.arguments.get("level"):
		start_game()


func _on_play_pressed() -> void:
	emit_signal("menu_changed")
	Music.fade_out()

	yield($"/root/Menu", "transition_finished")
	start_game()


func _on_options_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Options")


func _on_quit_pressed() -> void:
	emit_signal("menu_changed")
	Music.fade_out()

	yield($"/root/Menu", "transition_finished")
	get_tree().quit()


func _on_credits_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Credits")
