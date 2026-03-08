extends CharacterBody2D

@export var move_speed: float = 100.0
@export var walk_duration: float = 3.0
@export var idle_duration: float = 2.0
@export var hunger_reward: float = 30.0

var sprite: AnimatedSprite2D
var state_timer: float = 0.0
var is_walking: bool = false
var moving_right: bool = true


func _ready():
	sprite = $AnimatedSprite2D
	play_idle_animation()


func _physics_process(delta):
	handle_behavior(delta)


func handle_behavior(delta):
	state_timer += delta

	if is_walking:
		# Walking state
		var velocity := Vector2.ZERO
		velocity.x = move_speed if moving_right else -move_speed
		sprite.flip_h = not moving_right

		self.velocity = velocity
		move_and_slide()

		if state_timer >= walk_duration:
			state_timer = 0.0
			is_walking = false
			play_idle_animation()

	else:
		# Idle state
		self.velocity = Vector2.ZERO
		move_and_slide()

		if state_timer >= idle_duration:
			state_timer = 0.0
			is_walking = true
			moving_right = not moving_right
			play_walk_animation()


func play_idle_animation():
	# Randomly choose between idle and idle_2
	var idle_anim = "idle" if randf() > 0.5 else "idle_2"
	sprite.play(idle_anim)


func play_walk_animation():
	sprite.play("walk")


func die() -> void:
	sprite.play("death")
	velocity = Vector2.ZERO
	await sprite.animation_finished
	queue_free()


func get_hunger_reward() -> float:
	return hunger_reward
