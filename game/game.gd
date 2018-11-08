# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

signal bricks_changed
signal lives_changed

var lives := 3

# Level holder
var level: Node

# The number of destroyable bricks left (used to check if the "bricks" goal was completed)
var bricks_left := 0

func _ready() -> void:
	randomize()

	emit_signal("lives_changed", lives)

	change_level("1")

func change_level(level_name: String) -> void:
	if level:
		level.queue_free()

	level = load("res://levels/" + level_name + ".tscn").instance()
	add_child(level)

	bricks_left = level.get_tree().get_nodes_in_group("brick").size()
	emit_signal("bricks_changed", bricks_left)

func _on_brick_destroyed() -> void:
	bricks_left -= 1
	emit_signal("bricks_changed", bricks_left)

func _on_ball_fell() -> void:
	# TODO: Only remove one live if the last ball fell
	# (in case there are multiple balls)
	lives -= 1
	emit_signal("lives_changed", lives)
