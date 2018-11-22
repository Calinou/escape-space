# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends AudioStreamPlayer

func play_song(music: String) -> void:
	stream = load("res://" + music + ".ogg")
	play()
