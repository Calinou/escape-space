# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node
class_name Game

signal bricks_changed
signal goals_changed
signal time_limit_changed
signal time_left_changed
signal state_changed

# The music volume bias to apply to all levels (in decibels)
const MUSIC_VOLUME_DB_BIAS = -3.0

# The number of levels in the game
const LEVEL_MAX = 2

# Level holder
var level: Node

# The current level number
# For level rotation to work, level scenes should be named with numbers only
# (without leading zeroes)
var current_level: int

# The number of destroyable bricks left (used to check if the "bricks" goal was completed)
var bricks_left := 0 setget set_bricks_left

# Goal information
# Key is the description, value is the number of balls left
var goals := {} setget set_goals

# The current game state
enum State {
	PREGAME,
	PLAYING,
	WON,
	LOST,
}

var state: int setget set_state

onready var pregame_timer := $PregameTimer as Timer
onready var level_timer := $LevelTimer as Timer
onready var hud := $CanvasLayer/HUD as Control


func _ready() -> void:
	randomize()

	var cli_level = CommandLine.arguments.get("level")
	# Starting level can be specified using `--level=N` on the command line
	if cli_level != null:
		if int(cli_level) < 1 or int(cli_level) > LEVEL_MAX:
			push_error(
					'--level only accepts integer values between 1 and {level_max} ("{value}" given).' \
					.format({
						level_max = LEVEL_MAX,
						value = cli_level,
					})
			)
			get_tree().quit()
			return

	change_level(int(CommandLine.arguments.get("level", 1)))


func _process(_delta: float) -> void:
	if not level_timer.is_stopped():
		emit_signal("time_left_changed", level_timer.time_left)


# Changes to a new level and initializes data displayed by the HUD.
func change_level(level_name: int) -> void:
	if level_name > LEVEL_MAX:
		get_tree().change_scene("res://menu/menu.tscn")
		return

	current_level = level_name
	self.state = State.PREGAME

	if level:
		level.queue_free()

	level = load("res://levels/" + str(level_name) + ".tscn").instance()
	add_child(level)

	for info_trigger in get_tree().get_nodes_in_group("info_trigger"):
		info_trigger.connect("info_triggered", hud, "_on_info_triggered")

	self.bricks_left = get_tree().get_nodes_in_group("brick").size()
	self.goals = {}

	for goal in get_tree().get_nodes_in_group("goal"):
		self.goals[goal.description] = goal.balls_required

	Music.play_song(load("res://levels/" + str(level_name) + ".ogg"))
	Music.volume_db = level.music_volume_db + MUSIC_VOLUME_DB_BIAS
	Music.fade_in()

	# Set the time limit and prepare time HUD display
	level_timer.wait_time = level.time_limit
	emit_signal("time_limit_changed", level.time_limit)
	emit_signal("time_left_changed", level.time_limit)


# Checks whether the player is allowed to exit and starts the winning sequence
# if they are.
func _on_exit_requested() -> void:
	if bricks_left > 0:
		return

	# Check if all goals have been completed
	for goal in goals:
		if goals[goal] > 0:
			return

	# Player is allowed to exit
	self.state = State.WON


func _on_brick_destroyed() -> void:
	self.bricks_left -= 1


func _on_goal_ball_received(goal: Goal) -> void:
	self.goals[goal.description] = goal.balls_required


func _on_level_timer_timeout() -> void:
	self.state = State.LOST


func _on_pregame_timer_timeout() -> void:
	self.state = State.PLAYING


func set_state(p_state: int) -> void:
	state = p_state
	emit_signal("state_changed", p_state)

	match p_state:
		State.PREGAME:
			pregame_timer.start()

		State.PLAYING:
			level_timer.start()

		State.WON:
			yield(get_tree().create_timer(2.0), "timeout")
			# Go to the next level
			change_level(current_level + 1)

		State.LOST:
			yield(get_tree().create_timer(2.0), "timeout")
			# Restart the current level
			change_level(current_level)


func set_bricks_left(bricks: int) -> void:
	bricks_left = bricks
	emit_signal("bricks_changed", bricks)


func set_goals(p_goals: Dictionary) -> void:
	goals = p_goals
	emit_signal("goals_changed", goals)
