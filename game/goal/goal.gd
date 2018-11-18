# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name Goal

signal ball_received

export var description = ""
export(int, 1, 100) var balls_required := 10

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var ball_counter := $Panel/BallCounter as Label

func _ready() -> void:
	connect("ball_received", $"/root/Game", "_on_goal_ball_received")
	update_ball_counter(balls_required)

func update_ball_counter(balls: int) -> void:
	ball_counter.text = str(balls)

# The area's collision shape is disabled when the number of balls required
# reaches 0, so it won't be called anymore after the goal is complete
func _on_score_area_body_entered(body: PhysicsBody2D):
	if body is Ball:
		body.queue_free()
		balls_required -= 1
		update_ball_counter(balls_required)

		if balls_required == 0:
			animation_player.play("close")
			emit_signal("ball_received", self)
