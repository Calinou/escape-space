# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

onready var fullscreen_button := $VBoxContainer/Fullscreen/Button as Button

func _ready() -> void:
	fullscreen_button.pressed = OS.window_fullscreen
	fullscreen_button.text = tr("On") if fullscreen_button.pressed else tr("Off")

func _on_fullscreen_toggled(button_pressed: bool) -> void:
	fullscreen_button.text = tr("On") if button_pressed else tr("Off")
	Settings.set_fullscreen(button_pressed)

func _on_done_pressed():
	emit_signal("menu_changed", $"/root/Menu/Options")
