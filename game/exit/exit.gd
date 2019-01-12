# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name Exit

signal exit_requested

func _ready() -> void:
	connect("exit_requested", $"/root/Game", "_on_exit_requested")

func _on_exit_area_body_entered(body: PhysicsBody2D) -> void:
	if body is Paddle:
		emit_signal("exit_requested")
