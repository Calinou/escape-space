# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name Goal

export(int, 1, 100) var balls_required = 10

onready var BallCounter = $Panel/BallCounter as Label

func _ready() -> void:
	update_ball_counter(balls_required)

func update_ball_counter(balls: int) -> void:
	BallCounter.text = str(balls)

func _draw() -> void:
	draw_circle(Vector2(), 30.0, Color(0.3, 0.7, 1.0, 1))

func _on_score_area_body_entered(body: PhysicsBody2D):
	if body is Ball:
		var ball = body
		balls_required -= 1
		update_ball_counter(balls_required)
		ball.queue_free()
