# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends StaticBody2D
class_name Brick

signal brick_destroyed

# Probability of dropping an item is 1/`item_rarity`
export(int, 1, 100) var item_rarity = 10

# Items that can be dropped by the brick
# Must be valid scene files in `res://game/item/`, without the `.tscn` extension
var items = [
	"faster_ball",
	"slower_ball",
]

func _ready() -> void:
	connect("brick_destroyed", $"/root/Game", "_on_brick_destroyed")

func destroy() -> void:
	$AnimationPlayer.play("destroy")

	if randi() % item_rarity == 0:
		# Pick a random item and spawn it
		var item = load("res://game/item/" + items[randi() % items.size()] + ".tscn").instance()
		get_parent().add_child(item)
		item.position = position

	emit_signal("brick_destroyed")

func _on_animation_finished(animation: String) -> void:
	queue_free()
