# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends HBoxContainer

onready var spin_box := $SpinBox as SpinBox
onready var slider := $HSlider as Slider

# The slider's default value.
# Used to reset the slider to its default value when right-clicked
onready var default := slider.value


func _on_slider_value_changed(value: float) -> void:
	spin_box.value = value


func _on_spin_box_value_changed(value: float) -> void:
	slider.value = value


func _on_slider_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton and
		(event as InputEventMouseButton).button_index == BUTTON_RIGHT
	):
		slider.value = default
