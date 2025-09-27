extends Character
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_back","Move_front")
	if direction == 1:
		anim.flip_h = false
		anim.play("Run")
		velocity.x = direction * SPEED
	elif direction == -1:
		anim.flip_h = true
		anim.play("Run")
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	move_and_slide()
