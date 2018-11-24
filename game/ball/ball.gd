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
onready var preloader := $ResourcePreloader as ResourcePreloader
onready var bounce_sounds := [
	preloader.get_resource("bounce.0"),
	preloader.get_resource("bounce.1"),
	preloader.get_resource("bounce.2"),
	preloader.get_resource("bounce.3"),
]

#warning-ignore:unused_argument
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity = linear_velocity.clamped(MAX_SPEED)

	for body in get_colliding_bodies():
		if body is Paddle:
			claim()
		else:
			# Don't play a sound if touched by a paddle to avoid spam
			Sound.play(
				Sound.Type.POSITIONAL_2D,
				self,
				bounce_sounds[randi() % bounce_sounds.size()],
				range_lerp(linear_velocity.length(), 0, MAX_SPEED, -5.0, 5.0),
				range_lerp(linear_velocity.length(), 0, MAX_SPEED, 0.55, 1.05)
			)

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
	# Don't claim if the ball is currently being destroyed
	if not claimed and animation_player.current_animation != "destroy":
		animation_player.queue("claim")

	claimed = true
