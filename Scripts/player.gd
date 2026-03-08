extends CharacterBody2D

@export var move_speed: float = 500.0
@export var max_hunger: float = 100.0
@export var hunger_decay_rate: float = 5.0 # Hunger increases per second

var sprite: AnimatedSprite2D
var current_hunger: float = 100.0


func _ready():
	sprite = $AnimatedSprite2D
	sprite.play("idle")


func _physics_process(delta):
	handle_movement()
	handle_hunger(delta)


func handle_movement():
	var velocity := Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += move_speed
		sprite.flip_h = false
		sprite.play("walk")

	elif Input.is_action_pressed("ui_left"):
		velocity.x -= move_speed
		sprite.flip_h = true
		sprite.play("walk")

	else:
		sprite.play("idle")

	self.velocity = velocity
	move_and_slide()


func handle_hunger(delta):
	current_hunger -= hunger_decay_rate * delta
	current_hunger = clamp(current_hunger, 0.0, max_hunger)

	# Update UI
	var hunger_label: Label = $CanvasLayer/HungerLabel
	hunger_label.text = "Hunger: %.1f" % current_hunger

	if current_hunger <= 0:
		print("Monster is starving!")


func get_hunger() -> float:
	return current_hunger


func set_hunger(amount: float) -> void:
	current_hunger = amount
