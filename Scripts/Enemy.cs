using Godot;

public partial class Enemy : CharacterBody2D
{
	[Export] public float MoveSpeed = 100f;
	[Export] public float WalkDistance = 200f;
	[Export] public float HungerReward = 30f;

	private AnimatedSprite2D _sprite;
	private float _walkTimer = 0f;
	private float _walkDuration = 2f;
	private bool _movingRight = true;
	private Vector2 _startPosition;

	public override void _Ready()
	{
		_sprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		_startPosition = GlobalPosition;
		_sprite.Play("walk");
	}

	public override void _PhysicsProcess(double delta)
	{
		HandlePatrol(delta);
	}

	private void HandlePatrol(double delta)
	{
		_walkTimer += (float)delta;

		if (_walkTimer >= _walkDuration)
		{
			_movingRight = !_movingRight;
			_walkTimer = 0f;
		}

		Vector2 velocity = Vector2.Zero;
		velocity.X = _movingRight ? MoveSpeed : -MoveSpeed;
		_sprite.FlipH = !_movingRight;

		Velocity = velocity;
		MoveAndSlide();
	}

	public void Die()
	{
		_sprite.Play("death");
		Velocity = Vector2.Zero;
		await ToSignal(_sprite, AnimatedSprite2D.SignalName.AnimationFinished);
		QueueFree();
	}
}
