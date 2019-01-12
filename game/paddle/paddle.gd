# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
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
onready var camera := $Camera2D as Camera2D
onready var tween := $Tween as Tween

func _ready() -> void:
	game.connect("state_changed", self, "_on_game_state_changed")

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	motion = Vector2.ZERO

	if can_move:
		if Input.is_action_pressed("move_up"):
			motion.y = -1
		elif Input.is_action_pressed("move_down"):
			motion.y = 1

		if Input.is_action_pressed("move_left"):
			motion.x = -1
		elif Input.is_action_pressed("move_right"):
			motion.x = 1

	motion = motion.normalized()
	linear_velocity = (linear_velocity + motion * ACCELERATION * state.step) * FRICTION

	tween.start()
	tween.interpolate_property(
			camera,
			"zoom",
			camera.zoom,
			CAMERA_ZOOM_BASE * Vector2.ONE + CAMERA_ZOOM_FACTOR * linear_velocity.length() * Vector2.ONE, 0.125,
			Tween.TRANS_SINE,
			Tween.EASE_IN_OUT
	)

func _on_game_state_changed(state: int) -> void:
	match state:
		game.State.PREGAME:
			can_move = false
		game.State.PLAYING:
			can_move = true
