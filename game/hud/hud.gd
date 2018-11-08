# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var bricks_counter := $Vitals/Bricks/Counter as Label
onready var lives_counter := $Vitals/Lives/Counter as Label

func _on_bricks_changed(value: int) -> void:
	update_bricks(value)

func _on_lives_changed(value: int) -> void:
	update_lives(value)

func update_bricks(value: int) -> void:
	bricks_counter.text = str(value)

func update_lives(value: int) -> void:
	lives_counter.text = str(value)
