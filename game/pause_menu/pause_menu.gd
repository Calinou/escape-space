# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var game := $"/root/Game" as Node
onready var pause_options := $VBoxContainer as Control
onready var animation_player := $AnimationPlayer as AnimationPlayer

# Whether the game is paused (the pause menu will be displayed automatically)
var paused := false setget set_paused


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		self.paused = !self.paused


func _on_visibility_changed() -> void:
	if visible:
		(pause_options.get_child(0) as Control).grab_focus()


func _on_continue_pressed() -> void:
	self.paused = false


func _on_restart_level_pressed() -> void:
	self.paused = false
	game.change_level(game.current_level)


func _on_exit_to_menu_pressed() -> void:
	self.paused = false
	get_tree().change_scene("res://menu/menu.tscn")


func set_paused(p_paused: bool) -> void:
	# Make child controls non-interactive while the menu is fading out
	propagate_call("set", [
		"mouse_filter",
		Control.MOUSE_FILTER_STOP if p_paused else Control.MOUSE_FILTER_IGNORE
	])
	propagate_call("set", [
		"enabled_focus_mode",
		Control.FOCUS_ALL if p_paused else Control.FOCUS_NONE
	])

	# Visibility toggling is handled by the animation
	animation_player.play("fade_in" if p_paused else "fade_out")
	get_tree().paused = p_paused

	paused = p_paused
