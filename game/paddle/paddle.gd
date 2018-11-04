# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends KinematicBody2D
class_name Paddle

# Acceleration
# There is no maximum set speed because it depends on friction
const ACCELERATION = 3000

# The friction factor applied on each step
const FRICTION = 0.89

var motion := Vector2()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		motion.y -= ACCELERATION * delta
	elif Input.is_action_pressed("move_down"):
		motion.y += ACCELERATION * delta

	if Input.is_action_pressed("move_left"):
		motion.x -= ACCELERATION * delta
	elif Input.is_action_pressed("move_right"):
		motion.x += ACCELERATION * delta

	motion *= FRICTION

	move_and_slide(motion)
