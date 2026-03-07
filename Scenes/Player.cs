using Godot;

public partial class Player : CharacterBody2D
{
	[Export] public float MoveSpeed = 400f;

	private AnimatedSprite2D _sprite;

	public override void _Ready()
	{
		_sprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		_sprite.Play("idle");
	}

	public override void _PhysicsProcess(double delta)
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
}
