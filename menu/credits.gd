# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

signal menu_changed

const credits = {
	"Programming": [
		"Calinou",
	],
	"2D Art": [
		"Calinou",
		"Kenney",
	],
	"Sound Effects": [
		"aust_paul",
		"DrMinky",
		"rhodesmas",
		"manuts",
	],
	"Music": [
		"Andrey Avkhimovich",
	],
	"Miscellaneous": [
		"Powered by Godot Engine",
	],
}

onready var rich_text_label := $Panel/RichTextLabel as RichTextLabel

func _ready() -> void:
	# Construct BBCode from the credits dictionary
	var credits_text = "[center]"

	for section in credits:
		credits_text += "[color=#5fe8]———  [color=#fe8]{section}[/color]  ———[/color]\n\n" \
				.format({section = tr(section)})

		for person in credits[section]:
			credits_text += tr(person) + "\n"

		credits_text += "\n"

	credits_text += "[/center]"

	rich_text_label.bbcode_text = credits_text

func _on_back_pressed() -> void:
	emit_signal("menu_changed", $"/root/Menu/Control/Main")

	yield($"/root/Menu", "transition_finished")
	rich_text_label.scroll_to_line(0)
