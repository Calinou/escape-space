# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

onready var sound_volume_slider := $VBoxContainer/SoundVolume/HSlider as HSlider
onready var music_volume_slider := $VBoxContainer/MusicVolume/HSlider as HSlider

func _ready() -> void:
	connect("menu_changed", $"/root/Menu", "_on_menu_changed")
	sound_volume_slider.value = Settings.file.get_value("audio", "sound_volume", 0.0)
	music_volume_slider.value = Settings.file.get_value("audio", "music_volume", 0.0)

func _on_sound_volume_value_changed(value: float) -> void:
	# TODO: Set sound volume
	pass

func _on_music_volume_value_changed(value: float) -> void:
	# TODO: Set music volume
	pass

func _on_done_pressed():
	Settings.file.set_value("audio", "sound_volume", sound_volume_slider.value)
	Settings.file.set_value("audio", "music_volume", music_volume_slider.value)
	Settings.save()
	emit_signal("menu_changed", $"/root/Menu/Main")
