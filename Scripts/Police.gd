class_name Police
extends CharacterBody2D

@export var move_speed = 150.0
@export var detection_range = 200.0
@export var attack_damage = 10.0

@onready var sprite = $AnimatedSprite2D

var player = null
var state = "patrol"

func _ready():
	player = get_node("/root/main/Player")
	if sprite:
		sprite.play("Walk")

func _physics_process(delta):
	if player == null:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player < detection_range:
		state = "chase"
		chase_player()
	else:
		state = "patrol"
		patrol()

func patrol():
	var velocity = Vector2.ZERO
	velocity.x = move_speed
	sprite.flip_h = false
	self.velocity = velocity
	move_and_slide()

func chase_player():
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	self.velocity = direction * move_speed
	sprite.flip_h = direction.x < 0
	sprite.play("Walk")
	move_and_slide()

func take_damage(amount):
	print("Police taking damage!")
	sprite.play("Dead")
	self.velocity = Vector2.ZERO
	await sprite.animation_finished
	queue_free()
