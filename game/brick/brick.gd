# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name Brick

signal brick_destroyed

onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	connect("brick_destroyed", $"/root/Game", "_on_brick_destroyed")

func destroy() -> void:
	animation_player.play("destroy")
	emit_signal("brick_destroyed")

func _on_animation_finished(animation: String) -> void:
	queue_free()
