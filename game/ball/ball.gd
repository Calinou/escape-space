# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends RigidBody2D
class_name Ball

# The starting ball speed
const BASE_SPEED = 275

# The maximum ball speed
const MAX_SPEED = 600

# Speed factor on every bounce
var speed_factor := 1.01

# Whether the ball has been touched by a paddle or not
var claimed := false

onready var sprite = $Sprite as Sprite
onready var particles = $CPUParticles2D as CPUParticles2D

var motion := Vector2()

func _draw() -> void:
	draw_circle(Vector2(), 10.0, Color(0.9, 0.9, 0.9, 1))

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity = linear_velocity.clamped(MAX_SPEED)

	for body in get_colliding_bodies():
		if body is Paddle:
			claim()

		if not claimed:
			# Destroy unclaimed balls on their first collision
			queue_free()

# Called when the ball is claimed (i.e. touched by a paddle)
func claim():
	claimed = true
	sprite.modulate = Color(1.0, 0.65, 0.25, 0.7)
	particles.modulate = Color(1.0, 0.65, 0.25, 1.0)
