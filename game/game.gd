# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

signal bricks_changed
signal goals_changed

# Level holder
var level: Node

# The number of destroyable bricks left (used to check if the "bricks" goal was completed)
var bricks_left := 0 setget set_bricks_left

# Goal information
# Key is the description, value is the number of balls left
var goals := {} setget set_goals

func _ready() -> void:
	randomize()
	change_level("1")

# Changes to a new level and initializes data displayed by the HUD.
func change_level(level_name: String) -> void:
	if level:
		level.queue_free()

	level = load("res://levels/" + level_name + ".tscn").instance()
	add_child(level)

	self.bricks_left = level.get_tree().get_nodes_in_group("brick").size()
	self.goals = {}

	for goal in level.get_tree().get_nodes_in_group("goal"):
		self.goals[goal.description] = goal.balls_required

func _on_brick_destroyed() -> void:
	self.bricks_left -= 1

func _on_goal_ball_received(goal: Goal) -> void:
	self.goals[goal.description] = goal.balls_required

func set_bricks_left(bricks: int):
	bricks_left = bricks
	emit_signal("bricks_changed", bricks)

func set_goals(goals_: Dictionary):
	goals = goals_
	emit_signal("goals_changed", goals)
