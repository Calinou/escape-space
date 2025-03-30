# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name Brick

signal brick_destroyed

@onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	# Prevent a brick from being destroyed multiple times,
	# which would mess up the brick counter
	connect("brick_destroyed", Callable($"/root/Game", "_on_brick_destroyed").bind(), CONNECT_ONE_SHOT)


func destroy() -> void:
	animation_player.play("destroy")
	emit_signal("brick_destroyed")


func _on_animation_finished(_animation: String) -> void:
	queue_free()
