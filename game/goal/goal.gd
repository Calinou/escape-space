# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name Goal

export(int, 1, 100) var balls_required = 10

onready var animation_player = $AnimationPlayer as AnimationPlayer
onready var ball_counter = $Panel/BallCounter as Label

func _ready() -> void:
	update_ball_counter(balls_required)

func update_ball_counter(balls: int) -> void:
	ball_counter.text = str(balls)

func _draw() -> void:
	draw_circle(Vector2(), 30.0, Color(0.3, 0.7, 1.0, 1))

# The area's collision shape is disabled when the number of balls required
# reaches 0, so it won't be called anymore after the goal is complete
func _on_score_area_body_entered(body: PhysicsBody2D):
	if body is Ball:
		body.queue_free()
		balls_required -= 1
		update_ball_counter(balls_required)

		if balls_required == 0:
			animation_player.play("close")
