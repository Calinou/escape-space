# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

const CONFIG_PATH = "user://settings.ini"

var file := ConfigFile.new()

func _ready() -> void:
	# Loads existing configuration (if any) for use anywhere
	file.load(CONFIG_PATH)

	OS.window_fullscreen = bool(file.get_value("video", "fullscreen", false))

func _input(event: InputEvent) -> void:
	# Fullscreen toggle
	# This can be done from anywhere, so it should be in a singleton
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		file.set_value("video", "fullscreen", OS.window_fullscreen)
		save()

# Saves the configuration file with a pre-defined path.
# This method should be used over `Settings.file.save(path)`
# unless a custom path needs to be specified.
func save() -> void:
	file.save(CONFIG_PATH)
