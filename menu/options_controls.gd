# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

# The currently-edited input action
var current_action := ""

onready var action_list = $ActionList as VBoxContainer


func _ready() -> void:
	set_process_input(false)

	# Node names (purposely in `snake_case`) match input actions
	for node in action_list.get_children():
		var action: String = node.get_name()

		# Display and use the first key bound to the action
		# (ignoring gamepad events)
		var input_key: InputEvent
		for input_event in InputMap.get_action_list(action):
			if input_event is InputEventKey:
				input_key = input_event
				break

		var scancode: String = Settings.file.get_value(
				"input",
				action,
				OS.get_scancode_string(input_key.scancode)
		)
		var event := InputEventKey.new()
		event.scancode = OS.find_scancode_from_string(scancode)
		bind_event(action, event)

		var button := node.get_node("Button") as Button
		button.text = Settings.file.get_value("input", action, scancode)
		button.connect("pressed", self, "_wait_for_input", [action])


func _input(event: InputEvent) -> void:
	if current_action and event is InputEventKey and not event.is_action_pressed("ui_cancel"):
		var button := action_list.get_node(current_action).get_node("Button") as Button
		var scancode := OS.get_scancode_string(event.scancode)
		button.text = scancode
		button.pressed = false

		bind_event(current_action, event)
		Settings.file.set_value("input", current_action, scancode)
		Settings.save()

		# This makes sure Enter or Space do not re-trigger the key configuration sequence
		get_tree().set_input_as_handled()
		set_process_input(false)


func _wait_for_input(selected_action: String) -> void:
	current_action = selected_action
	set_process_input(true)


func _on_done_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Options")


# Removes existing key input events from an action and binds a new event to an action.
func bind_event(action: String, event: InputEvent) -> void:
	for old_event in InputMap.get_action_list(action):
		if old_event is InputEventKey:
			# Don't remove gamepad input events
			InputMap.action_erase_event(action, old_event)

	InputMap.action_add_event(action, event)
