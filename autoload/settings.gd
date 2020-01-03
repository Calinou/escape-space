# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

# Used for persistent settings
const CONFIG_PATH = "user://settings.ini"

# Used for "temporary" settings such as the last update check timestamp
const CONFIG_CACHE_PATH = "user://cache.ini"

var file := ConfigFile.new()
var cache := ConfigFile.new()


func _ready() -> void:
	# Keep the fullscreen toggle functional while the game is paused
	pause_mode = Node.PAUSE_MODE_PROCESS

	# Loads existing configuration (if any) for use anywhere
	file.load(CONFIG_PATH)
	cache.load(CONFIG_CACHE_PATH)

	OS.window_fullscreen = bool(file.get_value("video", "fullscreen", false))


func _input(event: InputEvent) -> void:
	# Fullscreen toggle
	# This can be done from anywhere, so it should be in a singleton
	if event.is_action_pressed("toggle_fullscreen"):
		set_fullscreen(!OS.window_fullscreen)


# Sets fullscreen status and persists it to the settings file.
func set_fullscreen(fullscreen: bool) -> void:
	OS.window_fullscreen = fullscreen
	file.set_value("video", "fullscreen", fullscreen)
	save()


# Saves configuration files with predefined paths.
# This method should be used over `Settings.file.save(path)`
# unless a custom path needs to be specified.
func save() -> void:
	var file_error := file.save(CONFIG_PATH)
	var cache_error := cache.save(CONFIG_CACHE_PATH)

	if file_error != OK or cache_error != OK:
		push_error("An error occurred while trying to save configuration files.")
