# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

func _ready():
	for button in get_tree().get_nodes_in_group("makes_sound"):
		if button is BaseButton:
			button.connect("mouse_entered", self, "_button_hovered", [button])
			button.connect("button_down", self, "_button_pressed", [button])

func _on_play_pressed() -> void:
	get_tree().change_scene("res://game/game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

# Plays a sound and frees the AudioStreamPlayer when the sound is done playing.
func play_sound(stream: AudioStream, volume_db: float) -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")

func _button_hovered(button: BaseButton) -> void:
	if not button.disabled:
		play_sound(preload("res://menu/hover.wav"), -5.5)

func _button_pressed(button: BaseButton) -> void:
	play_sound(preload("res://menu/click.wav"), -2.0)
