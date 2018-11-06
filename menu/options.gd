# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

func _ready() -> void:
	connect("menu_changed", $"/root/Menu", "_on_menu_changed")

func _on_done_pressed():
	emit_signal("menu_changed", $"/root/Menu/Main")
