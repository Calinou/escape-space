# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name BallLauncher

# Time between launches in seconds
export(float, 0.25, 5.0) var launch_time = 1.5

# The speed of launched balls in pixels/s
export(int, 10, 1000) var launch_speed = 200

onready var launch_position = $LaunchPosition as Position2D
onready var launch_timer = $LaunchTimer as Timer

func _ready() -> void:
	launch_timer.wait_time = launch_time

func _on_launch_timer_timeout() -> void:
	var ball = preload("res://game/ball/ball.tscn").instance()
	ball.position = launch_position.global_transform.origin
	ball.linear_velocity = Vector2(0, launch_speed)
	get_parent().add_child(ball)
