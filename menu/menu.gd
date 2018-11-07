# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

# The currently-viewed menu control
onready var current_menu = $"/root/Menu/Main" as Control

onready var animation_player = $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	animation_player.play("fade_in")

	for control in get_tree().get_nodes_in_group("makes_sound"):
		if control is BaseButton:
			control.connect("mouse_entered", self, "_control_hovered", [control])
			control.connect("button_down", self, "_control_pressed", [control])
		elif control is Slider:
			control.connect("mouse_entered", self, "_control_hovered", [control])

func _control_hovered(control: Control) -> void:
	if control is BaseButton and control.disabled:
		return

	play_sound(preload("res://menu/hover.wav"), -5.5)

func _control_pressed(control: Control) -> void:
	play_sound(preload("res://menu/click.wav"), -2.0)

# Called when a child GUI sets the currently-viewed GUI.
func _on_menu_changed(new_menu: Control) -> void:
	current_menu.visible = false
	new_menu.visible = true
	current_menu = new_menu

# Plays a sound and frees the AudioStreamPlayer when the sound is done playing.
func play_sound(stream: AudioStream, volume_db: float) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
