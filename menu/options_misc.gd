# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed
signal update_requested


func _on_done_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Options")
