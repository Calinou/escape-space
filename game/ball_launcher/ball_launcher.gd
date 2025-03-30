# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name BallLauncher

# Time between launches in seconds
@export var launch_time := 1.5 # (float, 0.25, 5.0)

# The speed of launched balls in pixels/s
@export var launch_speed := 200 # (int, 10, 1000)

@onready var launch_position := $LaunchPosition as Marker2D
@onready var launch_timer := $LaunchTimer as Timer
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var preloader := $ResourcePreloader as ResourcePreloader
@onready var ball_scene := preloader.get_resource("ball") as PackedScene


func _ready() -> void:
	$"/root/Game".connect("state_changed", Callable(self, "_on_game_state_changed"))
	launch_timer.wait_time = launch_time


func _on_launch_timer_timeout() -> void:
	animation_player.play("launch")
	var ball := ball_scene.instantiate()
	ball.position = launch_position.global_transform.origin
	ball.linear_velocity = Vector2(0, launch_speed).rotated(rotation)
	get_parent().add_child(ball)


func _on_game_state_changed(state: int) -> void:
	match state:
		Game.State.PREGAME:
			launch_timer.stop()
		Game.State.PLAYING:
			launch_timer.start()
			# Start launching balls immediately
			launch_timer.emit_signal("timeout")
