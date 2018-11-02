# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends KinematicBody2D
class_name Item

signal item_collected

const gravity = 250
var motion = Vector2()

# The reward in points for collecting the item
# Can be overriden on a per-item basis in the _ready() function
var score = 500

func _ready():
	connect("item_collected", $"/root/Game", "_on_item_collected")
	motion = Vector2(rand_range(-250, 250), -75)

func _physics_process(delta: float) -> void:
	motion.y += gravity * delta

	var collision = move_and_collide(motion * delta)

	if collision:
		motion = motion.bounce(collision.normal)

		if collision.collider is Paddle:
			emit_signal("item_collected", self)
			activate()
			queue_free()

func activate() -> void:
	# Define an effect in scenes inheriting from this one
	pass
