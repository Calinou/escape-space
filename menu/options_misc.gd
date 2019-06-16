# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed
signal update_requested

onready var check_updates_button := $VBoxContainer/CheckUpdates/Button as Button


func _ready() -> void:
	connect("update_requested", $"/root/Menu/Control/Main/UpdateChecker", "check_for_updates")

	check_updates_button.pressed = Settings.file.get_value(
			"network",
			"check_for_updates",
			ProjectSettings.get("application/config/check_for_updates")
	)
	check_updates_button.text = tr("On") if check_updates_button.pressed else tr("Off")


func _on_check_updates_toggled(button_pressed: bool) -> void:
	check_updates_button.text = tr("On") if button_pressed else tr("Off")
	Settings.file.set_value("network", "check_for_updates", button_pressed)
	Settings.save()

	if button_pressed:
		# Check for updates immediately if updates were previously disabled
		emit_signal("update_requested")


func _on_done_pressed():
	emit_signal("menu_changed", $"/root/Menu/Control/Options")
