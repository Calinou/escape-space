# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

# The currently-edited input action
var action: String

onready var action_list = $ActionList as VBoxContainer

func _ready() -> void:
	set_process_input(false)

	# Node names (purposely in `snake_case`) match input actions
	for node in action_list.get_children():
		var action: String = node.get_name()
		var scancode: String = Settings.file.get_value(
				"input",
				action,
				OS.get_scancode_string(InputMap.get_action_list(action)[0].scancode)
		)
		var event := InputEventKey.new()
		event.scancode = OS.find_scancode_from_string(scancode)
		bind_event(action, event)

		var button := node.get_node("Button") as Button
		button.text = Settings.file.get_value("input", action, scancode)
		button.connect("pressed", self, "_wait_for_input", [action])

func _input(event: InputEvent) -> void:
	if action and event is InputEventKey and not event.is_action_pressed("ui_cancel"):
		var button := action_list.get_node(action).get_node("Button") as Button
		var scancode := OS.get_scancode_string(event.scancode)
		button.text = scancode
		button.pressed = false

		bind_event(action, event)
		Settings.file.set_value("input", action, scancode)
		Settings.save()

		# This makes sure Enter or Space do not re-trigger the key configuration sequence
		get_tree().set_input_as_handled()
		set_process_input(false)

func _wait_for_input(selected_action: String) -> void:
	action = selected_action
	set_process_input(true)

func _on_done_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Options")

# Removes existing input events from an action and binds a new event to an action.
func bind_event(action: String, event: InputEvent) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
