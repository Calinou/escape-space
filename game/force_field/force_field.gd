@tool
# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends NinePatchRect
class_name ForceField

# The default width of the force field in pixels
const DEFAULT_WIDTH = 128

@onready var body := $StaticBody2D as StaticBody2D


func _ready() -> void:
	# Update the body's width to match the size of the NinePatchRect
	body.position.x = size.x / 2
	body.scale.x = float(size.x) / DEFAULT_WIDTH
