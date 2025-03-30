# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

# The currently-edited input action
var current_action := ""

@onready var action_list = $ActionList as VBoxContainer


func _ready() -> void:
	set_process_input(false)

	# Node names (purposely in `snake_case`) match input actions
	for node in action_list.get_children():
		var action: String = node.get_name()

		# Display and use the first key bound to the action
		# (ignoring gamepad events)
		var input_key: InputEvent
		for input_event in InputMap.action_get_events(action):
			if input_event is InputEventKey:
				input_key = input_event
				break

		var keycode: String = Settings.file.get_value(
				"input",
				action,
				OS.get_keycode_string(input_key.keycode)
		)
		var event := InputEventKey.new()
		event.keycode = OS.find_keycode_from_string(keycode)
		bind_event(action, event)

		var button := node.get_node("Button") as Button
		button.text = Settings.file.get_value("input", action, keycode)
		button.connect("pressed", Callable(self, "_wait_for_input").bind(action))


func _input(event: InputEvent) -> void:
	if current_action and event is InputEventKey and not event.is_action_pressed("ui_cancel"):
		var button := action_list.get_node(current_action).get_node("Button") as Button
		var keycode := OS.get_keycode_string(event.keycode)
		button.text = keycode
		button.button_pressed = false

		bind_event(current_action, event)
		Settings.file.set_value("input", current_action, keycode)
		Settings.save()

		# This makes sure Enter or Space do not re-trigger the key configuration sequence
		get_viewport().set_input_as_handled()
		set_process_input(false)


func _wait_for_input(selected_action: String) -> void:
	current_action = selected_action
	set_process_input(true)


func _on_done_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Options")


# Removes existing key input events from an action and binds a new event to an action.
func bind_event(action: String, event: InputEvent) -> void:
	for old_event in InputMap.action_get_events(action):
		if old_event is InputEventKey:
			# Don't remove gamepad input events
			InputMap.action_erase_event(action, old_event)

	InputMap.action_add_event(action, event)
