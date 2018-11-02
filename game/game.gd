# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

signal score_changed
signal lives_changed

var score = 0
var lives = 3

# Level holder
var level: Node

# The number of destroyable bricks left (used to check if the level was completed)
var bricks_left = 0

func _ready() -> void:
	randomize()

	# This is required to make the HUD display correct values on startup
	emit_signal("score_changed", score)
	emit_signal("lives_changed", lives)

	change_level("1")

func change_level(level_name: String) -> void:
	if level:
		level.queue_free()

	level = load("res://levels/" + level_name + ".tscn").instance()
	add_child(level)

	# `level.get_tree().get_nodes_in_group("ignore_in_brick_count").size()` only returns a correct result
	# if we wait one frame
	yield(get_tree(), "idle_frame")
	bricks_left = level.get_child_count() \
				- level.get_tree().get_nodes_in_group("ignore_in_brick_count").size()

func _on_brick_destroyed() -> void:
	score += 100
	bricks_left -= 1
	emit_signal("score_changed", score)

	if bricks_left <= 0:
		change_level("2")

func _on_item_collected(item: Item) -> void:
	score += item.score
	emit_signal("score_changed", score)

func _on_ball_fell() -> void:
	# TODO: Only remove one live if the last ball fell
	# (in case there are multiple balls)
	lives -= 1
	emit_signal("lives_changed", lives)
