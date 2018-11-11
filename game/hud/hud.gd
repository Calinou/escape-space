# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

var goal_scene := preload("res://game/hud/goal.tscn")

onready var bricks_counter := $Vitals/Bricks/Counter as Label
onready var goals := $Goals as VBoxContainer

func _on_bricks_changed(value: int) -> void:
	update_bricks(value)

func update_bricks(value: int) -> void:
	bricks_counter.text = str(value)

func _on_goals_changed(goals_data: Dictionary):
	# Clear existing goal data before displaying new data
	for goal in goals.get_children():
		goal.queue_free()

	for goal_data in goals_data:
		# Key is the description, value is the number of balls left
		var goal := goal_scene.instance()
		goal.get_node("Description").text = goal_data
		goal.get_node("Balls").text = str(goals_data[goal_data])

		if goals_data[goal_data] <= 0:
			goal.modulate = Color(1, 0.95, 0.6)
		else:
			goal.modulate = Color(0.6, 0.9, 1)

		goals.add_child(goal)
