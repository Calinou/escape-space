# Copyright © 2018 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends KinematicBody2D
class_name Ball

# Path to the paddle which will be used to (re)set the ball's position
export(NodePath) var start_paddle

var motion = Vector2()

# The starting ball speed
var base_speed = 275

# Speed factor on every bounce
var speed_factor = 1.01

# The maximum possible deflection
# (relatve to the ball's current horizontal speed)
var max_deflection = 300

func _draw() -> void:
	draw_circle(Vector2(), 10.0, Color(0.9, 0.9, 0.9, 1))

func _ready() -> void:
	reset()

func _physics_process(delta: float) -> void:
	return
	var collision = move_and_collide(motion * delta)

	if collision:
		$AudioStreamPlayer.stream = load("res://game/ball/bounce." + str(randi() % 4) + ".wav")
		$AudioStreamPlayer.play()
		motion = motion.bounce(collision.normal)
		motion *= speed_factor

		if collision.collider is Brick:
			var brick = collision.collider
			brick.destroy()

		if collision.collider is Paddle:
			var paddle = collision.collider
			var extents = paddle.get_node("CollisionShape2D").shape.extents.x

			# The ball will deflect if it hit close to one of the paddle's edges
			motion.x = max_deflection * (collision.position.x - paddle.position.x) / extents

func _on_ball_fell() -> void:
	reset()

func reset() -> void:
	var paddle = get_node(start_paddle)
	position = Vector2(paddle.position.x, paddle.position.y - 20)
	motion = Vector2(0, -base_speed)
