# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var score_counter := $Vitals/Score/Counter as Label
onready var lives_counter := $Vitals/Lives/Counter as Label

func _on_score_changed(value: int) -> void:
	update_score(value)

func _on_lives_changed(value: int) -> void:
	update_lives(value)

func update_score(value: int) -> void:
	score_counter.text = str(value)

func update_lives(value: int) -> void:
	lives_counter.text = str(value)
