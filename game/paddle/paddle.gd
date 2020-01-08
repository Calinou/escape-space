# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends RigidBody2D
class_name Paddle

# Acceleration
# There is no maximum set speed because it depends on friction
const ACCELERATION = 2400

# The friction factor applied on each step
const FRICTION = 0.9

const CAMERA_ZOOM_BASE = 1.5

# The zoom-out factor per pixel/s of movement
const CAMERA_ZOOM_FACTOR = 0.0005

# Where the player intends to go
var motion := Vector2()

# Whether the paddle is allowed to move
var can_move := false

onready var game := $"/root/Game" as Node
onready var camera := $Smoothing2D/Camera2D as Camera2D
onready var tween := $Smoothing2D/Tween as Tween


func _ready() -> void:
	game.connect("state_changed", self, "_on_game_state_changed")


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	motion = Vector2.ZERO

	if can_move:
		motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	motion = motion.clamped(1.0)
	linear_velocity = (linear_velocity + motion * ACCELERATION * state.step) * FRICTION

	tween.start()
	tween.interpolate_property(
			camera,
			"zoom",
			camera.zoom,
			CAMERA_ZOOM_BASE * Vector2.ONE + CAMERA_ZOOM_FACTOR * linear_velocity.length() * Vector2.ONE,
			0.125,
			Tween.TRANS_SINE,
			Tween.EASE_IN_OUT
	)


func _on_game_state_changed(state: int) -> void:
	match state:
		game.State.PREGAME:
			can_move = false
		game.State.PLAYING:
			can_move = true
