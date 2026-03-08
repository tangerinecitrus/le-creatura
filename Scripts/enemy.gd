class_name Enemy
extends CharacterBody2D

@export var move_speed = 100.0
@export var walk_duration = 3.0
@export var idle_duration = 2.0

@onready var sprite = $AnimatedSprite2D

var state_timer = 0.0
var is_walking = false
var moving_right = true

func _ready():
	play_idle_animation()

func _physics_process(delta):
	handle_behavior(delta)

func handle_behavior(delta):
	state_timer += delta
	
	if is_walking:
		# Walking state
		var velocity = Vector2.ZERO
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
	var idle_anim = "Idle" if randf() > 0.5 else "Idle_2"
	sprite.play(idle_anim)

func play_walk_animation():
	sprite.play("Walk")

func take_damage():
	self.velocity = Vector2.ZERO
	
	#Disables collision so it does not push the player
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true
			
	queue_free()
