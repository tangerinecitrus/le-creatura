# Player.gd
extends CharacterBody2D

@export var move_speed = 500.0
@export var max_hunger = 100.0
@export var hunger_decay_rate = 5.0
@export var attack_range = 50.0
@export var hunger_restore = 30.0
@export var kills_until_police = 5
@export var police_scene = preload("res://Scenes/Police.tscn")

var kill_count = 0

@onready var sprite = $AnimatedSprite2D
var hunger_label

var current_hunger = 100.0
var is_attacking = false
var current_direction = 1  # 1 for right, -1 for left

func _ready():
	sprite.play("idle")
	add_to_group("player")
	hunger_label = $CanvasLayer/HungerLabel

func _physics_process(delta):
	if not is_attacking:
		handle_movement()
		handle_hunger(delta)
	
	if Input.is_action_just_pressed("ui_accept"):  # Spacebar to attack
		perform_attack()

func handle_movement():
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += move_speed
		current_direction = 1
		sprite.flip_h = false
		sprite.play("walk")
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= move_speed
		current_direction = -1
		sprite.flip_h = true
		sprite.play("walk")
	else:
		sprite.play("idle")
	
	self.velocity = velocity
	move_and_slide()

func handle_hunger(delta):
	current_hunger -= hunger_decay_rate * delta
	current_hunger = clamp(current_hunger, 0.0, max_hunger)
	
	hunger_label.text = "Hunger: %.1f" % current_hunger
	
	if current_hunger <= 0:
		print("Monster is starving!")

func perform_attack():
	is_attacking = true
	
	# Determine attack animation
	var attack_anim = "attack1"
	sprite.play(attack_anim)
	
	var attack_duration = 0.9
	
	# Check for enemies in range IMMEDIATELY
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = attack_range
	query.shape = shape
	query.transform = global_transform
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		if result.collider is Enemy:
			result.collider.take_damage()
			restore_hunger(hunger_restore)
	
	await get_tree().create_timer(attack_duration).timeout
	is_attacking = false

func restore_hunger(amount):
	current_hunger += amount
	current_hunger = clamp(current_hunger, 0, max_hunger)
	kill_count += 1
	print("Kills: %d" % kill_count)
	
	if kill_count >= kills_until_police:
		spawn_police()

func spawn_police():
	print("Police spawning!")
	var police = police_scene.instantiate()
	get_parent().add_child(police)
	police.global_position = global_position + Vector2(200, 0)
	kill_count = 0  # Reset counter
