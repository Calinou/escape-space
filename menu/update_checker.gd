# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Control

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var version_label := $Version as Label
onready var update_button := $Update as Button
onready var http_request := $HTTPRequest as HTTPRequest

# Only update once every UPDATE_THROTTLE seconds at most
# The GitHub releases API only allows 60 unauthenticated requests per hour,
# so this value should be kept relatively high
const UPDATE_THROTTLE = 600

# If an update is less than VERSION_DATE_BIAS seconds newer than the
# current version, then it won't be considered as a new version.
# This is done to account for deployment taking some time after the
# project is built
const VERSION_DATE_BIAS = 600

func _ready() -> void:
	version_label.text = ProjectSettings.get("application/config/version")

	# User preference overrides the setting defined on export
	if Settings.file.get_value("network", "check_for_updates", ProjectSettings.get("application/config/check_for_updates")):
		check_for_updates()

# TODO: Check for stable releases only (depending on user preference)
func check_for_updates() -> void:
	if OS.get_unix_time() < Settings.cache.get_value("updates", "last_check", 0) + UPDATE_THROTTLE:
		print("INFO: Skipping update check since updates were recently checked.")
		return
	else:
		print("INFO: Checking for updates…")

	http_request.request(
			"https://api.github.com/repos/{user}/{repository}/releases".format({
					user = ProjectSettings.get("application/config/github_user"),
					repository = ProjectSettings.get("application/config/github_repository"),
			})
	)

func _on_http_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		# The request failed for any reason, abort
		print("ERROR: Could not check for updates due to a network error.")
		return
	else:
		print("INFO: Update check successful.")

	# Store timestamp of last successful update check (used for throttling)
	Settings.cache.set_value("updates", "last_check", OS.get_unix_time())
	Settings.save()

	var json = parse_json(body.get_string_from_utf8())
	var latest_unix = OS.get_unix_time_from_datetime(parse_date(json[0].created_at))

	if latest_unix > ProjectSettings.get("application/config/version_date") + VERSION_DATE_BIAS:
		animation_player.play("fade_in")

		# Set the URL that will be opened when the button is pressed
		update_button.set_meta("url", json[0].html_url)

func _on_update_pressed() -> void:
	OS.shell_open(update_button.get_meta("url"))

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
