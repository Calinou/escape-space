# Copyright © 2019-2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends CanvasModulate

# Output color will be multiplied by this value
var intensity := 1.0 setget set_intensity


func _ready() -> void:
	self.intensity = float(Settings.file.get_value("video", "brightness", 1.0))


func set_intensity(p_intensity: float) -> void:
	color = Color(p_intensity, p_intensity, p_intensity, 1)
	intensity = p_intensity
