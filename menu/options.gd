# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

func _on_video_settings_pressed():
	pass # Replace with function body.

func _on_audio_settings_pressed():
	emit_signal("menu_changed", $"/root/Menu/OptionsAudio")

func _on_controls_pressed():
	emit_signal("menu_changed", $"/root/Menu/OptionsControls")

func _on_done_pressed():
	emit_signal("menu_changed", $"/root/Menu/Main")
