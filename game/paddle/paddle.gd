# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends KinematicBody2D
class_name Paddle

# Acceleration
# There is no maximum set speed because it depends on friction
const ACCELERATION = 3000

# The friction factor applied on each step
const FRICTION = 0.89

# Where the paddle is aiming to go
var direction := Vector2()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		direction.y -= ACCELERATION * delta
	elif Input.is_action_pressed("move_down"):
		direction.y += ACCELERATION * delta

	if Input.is_action_pressed("move_left"):
		direction.x -= ACCELERATION * delta
	elif Input.is_action_pressed("move_right"):
		direction.x += ACCELERATION * delta

	direction *= FRICTION

	move_and_slide(direction)
