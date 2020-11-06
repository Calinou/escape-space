# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
# This is a tool script so the pseudo-3D effect can be previewed in the editor.
tool
extends Node2D

# This script should be attached to the root node of each level to define exported variables

# The number of iterations to use for the pseudo-3D look.
# Higher number of iterations looks better, but is slower.
const ITERATIONS = 10

# The time limit in seconds
#warning-ignore:unused_class_variable
export(int, 1, 1000) var time_limit := 180

# The music volume offset in decibels
#warning-ignore:unused_class_variable
export(float, -50.0, 0.0) var music_volume_db := 0.0


onready var foreground := $Foreground as TileMap

func _ready() -> void:
	# Create duplicate tilemap layers for a pseudo-3D look.
	for i in ITERATIONS:
		var canvas_layer := CanvasLayer.new()
		# Make the TileMap draw in front of the background but behind the HUD and entities.
		canvas_layer.layer = 0
		canvas_layer.follow_viewport_enable = 1
		canvas_layer.follow_viewport_scale = 1 + int(i) * 0.01
		var tilemap := foreground.duplicate(0) as TileMap
		# Brighten closer tilemaps to add a basic shading/fake contrast effect.
		var brightness := 1 + int(i) * 0.03
		tilemap.modulate = Color(brightness, brightness, brightness)
		canvas_layer.add_child(tilemap)
		call_deferred("add_child", canvas_layer)
