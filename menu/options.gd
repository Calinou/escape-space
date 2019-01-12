# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

func _on_video_settings_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/OptionsVideo")

func _on_audio_settings_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/OptionsAudio")

func _on_controls_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/OptionsControls")

func _on_misc_settings_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/OptionsMisc")

func _on_done_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Main")
