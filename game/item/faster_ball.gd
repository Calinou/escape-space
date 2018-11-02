# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Item
class_name FasterBallItem

func _ready() -> void:
	# This item makes gameplay more difficult, so the reward is higher
	score = 1000

func activate() -> void:
	for ball in $"/root/Game".get_tree().get_nodes_in_group("ball"):
		ball.motion *= 1.5
