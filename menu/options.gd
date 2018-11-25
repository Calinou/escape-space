# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

func _on_video_settings_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/OptionsVideo")

func _on_audio_settings_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/OptionsAudio")

func _on_controls_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/OptionsControls")

func _on_misc_settings_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/OptionsMisc")

func _on_done_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Main")
