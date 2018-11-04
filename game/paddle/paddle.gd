# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends RigidBody2D
class_name Paddle

# Acceleration
# There is no maximum set speed because it depends on friction
const ACCELERATION = 3000

# The friction factor applied on each step
const FRICTION = 0.89

var motion := Vector2()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if Input.is_action_pressed("move_up"):
		motion.y -= ACCELERATION * state.step
	elif Input.is_action_pressed("move_down"):
		motion.y += ACCELERATION * state.step

	if Input.is_action_pressed("move_left"):
		motion.x -= ACCELERATION * state.step
	elif Input.is_action_pressed("move_right"):
		motion.x += ACCELERATION * state.step

	motion *= FRICTION

	linear_velocity = motion
