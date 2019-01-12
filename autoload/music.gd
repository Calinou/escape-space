# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends AudioStreamPlayer

# Used to animate the master bus volume for fade in/out effects
export(float, -50.0, 0.0) var master_volume := 0.0 setget set_master_volume

onready var animation_player := $AnimationPlayer as AnimationPlayer

func play_song(music: AudioStream) -> void:
	stream = music
	play()

func fade_in() -> void:
	animation_player.play("fade_in")

func fade_out() -> void:
	animation_player.play_backwards("fade_in")

func set_master_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			volume_db
	)
	master_volume = volume_db
