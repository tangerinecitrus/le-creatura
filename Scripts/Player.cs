using Godot;

public partial class Player : CharacterBody2D
{
	[Export] public float MoveSpeed = 500f;
	[Export] public float MaxHunger = 100f;
	[Export] public float HungerDecayRate = 5f; // Hunger increases per second

	private AnimatedSprite2D _sprite;
	private float _currentHunger = 100f;

	public override void _Ready()
	{
		_sprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		_sprite.Play("idle");
	}

	public override void _PhysicsProcess(double delta)
	{
		HandleMovement();
		HandleHunger(delta);
	}

	private void HandleMovement()
	{
		Vector2 velocity = Vector2.Zero;

		if (Input.IsActionPressed("ui_right"))
		{
			velocity.X += MoveSpeed;
			_sprite.FlipH = false;
			_sprite.Play("walk");
		}
		else if (Input.IsActionPressed("ui_left"))
		{
			velocity.X -= MoveSpeed;
			_sprite.FlipH = true;
			_sprite.Play("walk");
		}
		else
		{
			_sprite.Play("idle");
		}

		Velocity = velocity;
		MoveAndSlide();
	}

	private void HandleHunger(double delta)
{
	_currentHunger -= HungerDecayRate * (float)delta;
	_currentHunger = Mathf.Clamp(_currentHunger, 0, MaxHunger);

	// Update UI
	var hungerLabel = GetNode<Label>("CanvasLayer/HungerLabel");
	hungerLabel.Text = $"Hunger: {_currentHunger:F1}";

	if (_currentHunger <= 0)
	{
		GD.Print("Monster is starving!");
	}
}

	public float GetHunger() => _currentHunger;
	public void SetHunger(float amount) => _currentHunger = amount;
}
