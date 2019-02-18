# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends HBoxContainer

onready var spin_box := $SpinBox as SpinBox
onready var slider := $HSlider as Slider

func _on_slider_value_changed(value: float) -> void:
	spin_box.value = value

func _on_spin_box_value_changed(value: float) -> void:
	slider.value = value
