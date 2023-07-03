# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

# The parallax background motion
var motion := Vector2()

# The currently-viewed menu control
onready var current_menu := $"/root/Menu/Control/Main" as Control

onready var root_control := $Control as Control
onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var background := $ParallaxBackground as ParallaxBackground
onready var preloader := $ResourcePreloader as ResourcePreloader
onready var hover_sound := preloader.get_resource("hover") as AudioStream
onready var click_sound := preloader.get_resource("click") as AudioStream

signal transition_finished


func _ready() -> void:
	animation_player.play("fade_in")
	Music.play_song(preload("res://menu/menu.ogg"))

	# Connect menu nodes for menu transitions
	for control in root_control.get_children():
		if control.get_script() and control.get_script().has_script_signal("menu_changed"):
			control.connect("menu_changed", self, "_on_menu_changed")

	# Connect any nodes that play a sound when hovered/pressed
	for control in get_tree().get_nodes_in_group("makes_sound"):
		if control is BaseButton:
			control.connect("mouse_entered", self, "_control_hovered", [control])
			control.connect("button_down", self, "_control_pressed", [control])
		elif control is Slider:
			control.connect("mouse_entered", self, "_control_hovered", [control])

	grab_autofocus()


func _input(event: InputEvent) -> void:
	# Move the background as the mouse moves
	if event is InputEventMouseMotion:
		motion += event.relative


func _process(_delta: float) -> void:
	motion *= 0.95
	background.scroll_offset += motion


func _control_hovered(control: Control) -> void:
	if control is BaseButton and not control.disabled:
		Sound.play(Sound.Type.NON_POSITIONAL, self, hover_sound, -5.5)


func _control_pressed(_control: Control) -> void:
	Sound.play(Sound.Type.NON_POSITIONAL, self, click_sound, -2.0)


# Called when a child GUI sets the currently-viewed GUI.
# If no GUI is set, then the screen will fade to black; this is
# typically used for an action that will leave the menu
# (such as starting the game or quitting).
func _on_menu_changed(new_menu: Control = null) -> void:
	if new_menu:
		animation_player.play("change_menu")
		# Change the GUI when the animation is halfway done
		yield(
			get_tree().create_timer(animation_player.current_animation_length / 2),
			"timeout"
		)

		current_menu.visible = false
		new_menu.visible = true
		current_menu = new_menu
		grab_autofocus()
	else:
		animation_player.play_backwards("fade_in")
		yield(animation_player, "animation_finished")

	emit_signal("transition_finished")


# Focus the first visible node with the "autofocus" group.
func grab_autofocus():
	for autofocus_node in get_tree().get_nodes_in_group("autofocus"):
		if current_menu.is_a_parent_of(autofocus_node):
			autofocus_node.grab_focus()
			break
