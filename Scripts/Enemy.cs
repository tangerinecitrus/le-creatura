using Godot;

public partial class Enemy : CharacterBody2D
{
	[Export] public float MoveSpeed = 100f;
	[Export] public float WalkDuration = 3f;
	[Export] public float IdleDuration = 2f;
	[Export] public float HungerReward = 30f;

	private AnimatedSprite2D _sprite;
	private float _stateTimer = 0f;
	private bool _isWalking = false;
	private bool _movingRight = true;

	public override void _Ready()
	{
		_sprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		PlayIdleAnimation();
	}

	public override void _PhysicsProcess(double delta)
	{
		HandleBehavior(delta);
	}

	private void HandleBehavior(double delta)
	{
		_stateTimer += (float)delta;

		if (_isWalking)
		{
			// Walking state
			Vector2 velocity = Vector2.Zero;
			velocity.X = _movingRight ? MoveSpeed : -MoveSpeed;
			_sprite.FlipH = !_movingRight;

			Velocity = velocity;
			MoveAndSlide();

			if (_stateTimer >= WalkDuration)
			{
				_stateTimer = 0f;
				_isWalking = false;
				PlayIdleAnimation();
			}
		}
		else
		{
			// Idle state
			Velocity = Vector2.Zero;
			MoveAndSlide();

			if (_stateTimer >= IdleDuration)
			{
				_stateTimer = 0f;
				_isWalking = true;
				_movingRight = !_movingRight;
				PlayWalkAnimation();
			}
		}
	}

	private void PlayIdleAnimation()
	{
		// Randomly choose between idle and idle_2
		string idleAnim = GD.Randf() > 0.5f ? "idle" : "idle_2";
		_sprite.Play(idleAnim);
	}

	private void PlayWalkAnimation()
	{
		_sprite.Play("walk");
	}

	public async void Die()
	{
		_sprite.Play("death");
		Velocity = Vector2.Zero;
		await ToSignal(_sprite, AnimatedSprite2D.SignalName.AnimationFinished);
		QueueFree();
	}

	public float GetHungerReward() => HungerReward;
}
