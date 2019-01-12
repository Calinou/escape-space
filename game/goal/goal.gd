# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node
class_name Goal

signal ball_received

# Short description to be displayed by the HUD
#warning-ignore:unused_class_variable
export var description = ""
export(int, 1, 100) var balls_required := 10

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var ball_counter := $Panel/BallCounter as Label
onready var preloader := $ResourcePreloader as ResourcePreloader
onready var get_ball_sound := preloader.get_resource("get_ball")
onready var close_sound := preloader.get_resource("close")

func _ready() -> void:
	connect("ball_received", $"/root/Game", "_on_goal_ball_received")
	update_ball_counter(balls_required)

func update_ball_counter(balls: int) -> void:
	ball_counter.text = str(balls)

# The area's collision shape is disabled when the number of balls required
# reaches 0, so it won't be called anymore after the goal is complete
func _on_score_area_body_entered(body: PhysicsBody2D):
	if body is Ball:
		body.get_node("AnimationPlayer").play("score")
		balls_required -= 1
		update_ball_counter(balls_required)
		emit_signal("ball_received", self)

		if balls_required == 0:
			animation_player.play("close")
			Sound.play(Sound.Type.POSITIONAL_2D, self, close_sound, 4.0)
		else:
			animation_player.play("get_ball")
			Sound.play(
					Sound.Type.POSITIONAL_2D,
					self,
					get_ball_sound,
					4.0,
					rand_range(0.94, 1.06)
			)
