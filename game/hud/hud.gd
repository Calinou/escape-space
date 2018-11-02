# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var ScoreCounter = $Vitals/Score/Counter
onready var LivesCounter = $Vitals/Lives/Counter

func _on_score_changed(value: int) -> void:
	update_score(value)

func _on_lives_changed(value: int) -> void:
	update_lives(value)

func update_score(value: int) -> void:
	ScoreCounter.text = str(value)

func update_lives(value: int) -> void:
	LivesCounter.text = str(value)
