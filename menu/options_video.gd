# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

onready var fullscreen_button := $VBoxContainer/Fullscreen/Button as Button
onready var brightness_slider := $VBoxContainer/Brightness/HSlider as HSlider

func _ready() -> void:
	fullscreen_button.pressed = OS.window_fullscreen
	fullscreen_button.text = tr("On") if fullscreen_button.pressed else tr("Off")
	brightness_slider.value = float(Settings.file.get_value("video", "brightness", 1.0))

	# Apply initial configuration settings (only really useful in the first start)
	brightness_slider.emit_signal("value_changed", brightness_slider.value)

func _on_fullscreen_toggled(button_pressed: bool) -> void:
	fullscreen_button.text = tr("On") if button_pressed else tr("Off")
	Settings.set_fullscreen(button_pressed)

func _on_brightness_value_changed(value: float) -> void:
	ColorCorrection.intensity = value

func _on_done_pressed():
	Settings.file.set_value("video", "brightness", brightness_slider.value)
	Settings.save()
	emit_signal("menu_changed", $"/root/Menu/Control/Options")
