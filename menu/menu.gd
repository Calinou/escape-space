# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

# The currently-viewed menu control
onready var current_menu := $"/root/Menu/Main" as Control

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var preloader := $ResourcePreloader as ResourcePreloader
onready var hover_sound := preloader.get_resource("hover") as AudioStream
onready var click_sound := preloader.get_resource("click") as AudioStream

signal transition_finished

func _ready() -> void:
	animation_player.play("fade_in")
	Music.play_song(preload("res://menu/menu.ogg"))

	for control in get_tree().get_nodes_in_group("makes_sound"):
		if control is BaseButton:
			control.connect("mouse_entered", self, "_control_hovered", [control])
			control.connect("button_down", self, "_control_pressed", [control])
		elif control is Slider:
			control.connect("mouse_entered", self, "_control_hovered", [control])

func _control_hovered(control: Control) -> void:
	if control is BaseButton and control.disabled:
		return

	Sound.play(Sound.Type.NON_POSITIONAL, self, hover_sound, -5.5)

func _control_pressed(control: Control) -> void:
	Sound.play(Sound.Type.NON_POSITIONAL, self, click_sound, -2.0)

# Called when a child GUI sets the currently-viewed GUI.
# If no GUI is set, then only the animation will be played;
# the child GUI will have to handle the action by itself.
func _on_menu_changed(new_menu: Control = null) -> void:
	animation_player.play("change_menu")

	# Change the GUI when the animation is halfway done
	yield(
			get_tree().create_timer(animation_player.current_animation_length / 2),
			"timeout"
	)

	if new_menu:
		current_menu.visible = false
		new_menu.visible = true
		current_menu = new_menu

	emit_signal("transition_finished")
