# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var color_rect_animation := $ColorRect/AnimationPlayer as AnimationPlayer
onready var bricks_counter := $Vitals/Bricks/Counter as Label
onready var center_label := $CenterText as RichTextLabel
onready var center_label_animation := $CenterText/AnimationPlayer as AnimationPlayer
onready var center_label_timer := $CenterText/Timer as Timer
onready var info_label := $InfoText as RichTextLabel
onready var info_label_animation := $InfoText/AnimationPlayer as AnimationPlayer
onready var info_label_timer := $InfoText/Timer as Timer
onready var goals := $Goals as Control
onready var time_label := $Time/Label as Label
onready var time_progress := $Time/TextureProgress as Range
onready var preloader := $ResourcePreloader as ResourcePreloader
onready var goal_scene := preloader.get_resource("goal") as PackedScene
onready var time_gradient := preloader.get_resource("time_gradient") as Gradient

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_hud"):
		for node in get_tree().get_nodes_in_group("can_hide"):
			node.visible = !node.visible

func _on_bricks_changed(value: int) -> void:
	update_bricks(value)

func update_bricks(value: int) -> void:
	bricks_counter.text = str(value)

func _on_goals_changed(goals_data: Dictionary) -> void:
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

func _on_time_left_changed(time: float) -> void:
	var color := time_gradient.interpolate(time / time_progress.max_value)

	time_label.text = str(int(time) / 60) + ":" + str(int(time) % 60).pad_zeros(2)
	time_label.modulate = color
	time_progress.value = time
	time_progress.modulate = color

func _on_time_limit_changed(time_limit: int) -> void:
	time_progress.max_value = time_limit

func _on_game_state_changed(state: int) -> void:
	match state:
		Game.State.PREGAME:
			set_center_text("[color=#ffee44]Get ready…[/color]")
		Game.State.PLAYING:
			set_center_text("[color=#66ff44]GO![/color]", 0.5)
		Game.State.WON:
			color_rect_animation.play_backwards("fade_in")

func set_center_text(text: String, duration: float = 6.0) -> void:
	center_label.bbcode_text = "[center]" + text + "[/center]"
	center_label_timer.wait_time = duration
	center_label_timer.start()

	yield(center_label_timer, "timeout")
	center_label_animation.play("fade_out")

func set_info_text(text: String, duration: float = 6.0) -> void:
	info_label.bbcode_text = "[center]" + text + "[/center]"
	info_label_timer.wait_time = duration
	info_label_timer.start()

	yield(info_label_timer, "timeout")
	info_label_animation.play("fade_out")
