# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

const CONFIG_PATH = "user://settings.ini"

var file := ConfigFile.new()

func _ready() -> void:
	# Loads existing configuration (if any) for use anywhere
	file.load(CONFIG_PATH)

# Saves the configuration file with a pre-defined path.
# This method should be used over `Settings.file.save(path)`
# unless a custom path needs to be specified.
func save() -> void:
	file.save(CONFIG_PATH)
