# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Item
class_name SlowerBallItem

func activate() -> void:
	for ball in $"/root/Game".get_tree().get_nodes_in_group("ball"):
		ball.motion *= 0.7
