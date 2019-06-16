# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Area2D

signal info_triggered

# The text to display when triggered
export(String, MULTILINE) var text := ""

onready var game := $"/root/Game" as Node
onready var cooldown := $Cooldown as Timer
onready var shape := $CollisionShape2D as CollisionShape2D

# Toggling the collision shape must be done on idle time,
# so `set_deferred()` is used


func _ready() -> void:
	game.connect("state_changed", self, "_on_game_state_changed")


func _on_body_entered(_body: PhysicsBody2D) -> void:
	emit_signal("info_triggered", tr(text))
	cooldown.start()
	shape.set_deferred("disabled", true)


func _on_cooldown_timeout() -> void:
	shape.set_deferred("disabled", false)


func _on_game_state_changed(state: int) -> void:
	match state:
		Game.State.PREGAME, \
		Game.State.WON, \
		Game.State.LOST:
			shape.set_deferred("disabled", true)
		Game.State.PLAYING:
			shape.set_deferred("disabled", false)
