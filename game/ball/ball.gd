# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends RigidBody2D
class_name Ball

# The starting ball speed
const BASE_SPEED = 275

# The maximum ball speed
const MAX_SPEED = 600

# Whether the ball has been touched by a paddle or not
var claimed := false

onready var animation_player := $AnimationPlayer as AnimationPlayer

#warning-ignore:unused_argument
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity = linear_velocity.clamped(MAX_SPEED)

	for body in get_colliding_bodies():
		if body is Paddle:
			claim()

		if body is Brick:
			body.destroy()

		if not claimed:
			# Destroy unclaimed balls on their first collision
			animation_player.play("destroy")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "destroy":
		queue_free()

# Called when the ball is claimed (i.e. touched by a paddle).
func claim():
	if not claimed:
		animation_player.play("claim")

	claimed = true
