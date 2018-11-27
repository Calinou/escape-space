# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Area2D

signal info_triggered

# The text to display when triggered
export(String, MULTILINE) var text := ""

# Whether the area can be triggered
var can_trigger := true

onready var cooldown := $Cooldown as Timer

func _on_body_entered(body: PhysicsBody2D) -> void:
	if can_trigger:
		emit_signal("info_triggered", tr(text))
		can_trigger = false
		cooldown.start()

func _on_cooldown_timeout() -> void:
	can_trigger = true
