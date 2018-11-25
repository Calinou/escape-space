# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var version_label := $Version as Label
onready var update_button := $Update as Button
onready var http_request := $HTTPRequest as HTTPRequest

func _ready() -> void:
	version_label.text = ProjectSettings.get("application/config/version")

	if ProjectSettings.get("application/config/check_for_updates"):
		check_for_updates()

func check_for_updates() -> void:
	http_request.request(
			"https://api.github.com/repos/{user}/{repository}/releases".format({
					user = ProjectSettings.get("application/config/github_user"),
					repository = ProjectSettings.get("application/config/github_repository"),
			})
	)

func _on_http_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = parse_json(body.get_string_from_utf8())
	var latest_unix = OS.get_unix_time_from_datetime(parse_date(json[0].created_at))

	if latest_unix > ProjectSettings.get("application/config/version_date"):
		update_button.visible = true

# Parses an ISO-8601 date string to a datetime dictionary that can be parsed by Godot.
func parse_date(iso_date: String) -> Dictionary:
	var date := iso_date.split("T")[0].split("-")
	var time := iso_date.split("T")[1].trim_suffix("Z").split(":")

	return {
		year = date[0],
		month = date[1],
		day = date[2],
		hour = time[0],
		minute = time[1],
		second = time[2],
	}
