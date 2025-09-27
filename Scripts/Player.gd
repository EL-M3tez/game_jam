extends Character1


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export_category("movement category")
@export var decceleration = 0.1
@export var speed = 120
@export var gravity = 500.0
var movement = Vector2()
@export_category("Jump")
@export var jump_speed = 190.0
@export var acceleration = 290.0
@export var jump_amount = 2
@export_category("wall jump")
@export var wall_slide = 10
@onready var right: RayCast2D = $Right
@onready var left: RayCast2D = $Left

@export var wall_x_force = 220.0
@export var wall_y_force = -220.0
var is_wall_jumping = false

@export_category("dash value")
@export var dash_speed = 400
@export var facing_right = true
@export var dash_gravity = 0
var dash_key_pressed = 0
var is_dashing = false
var dash_timer = Timer

func _physics_process(delta: float) -> void:
	print(health)
	if health == 0:
		pass
	if is_dashing ==false:
		velocity.y += delta * gravity
	elif is_dashing == true:
		velocity.y = dash_gravity
	horizontal_movement()
	jump_logic()
	wall_logic()
	
	set_animation()
	move_and_slide()
	flip()
	
	
func horizontal_movement():
	if is_wall_jumping == false:
		movement = Input.get_axis("Move_back","Move_front")
		if movement : 
			velocity.x = speed*movement
		else: 
			velocity.x = move_toward(velocity.x, 0,speed*decceleration )
	if Input.is_action_just_pressed("dash") and dash_key_pressed==0:
		dash_key_pressed= 1
		dash()
func set_animation():
	if velocity.x !=0 :
		anim.play("Run")
	if velocity.x==0:
		anim.play("Idle")
	if is_on_wall_only():
		anim.play("Wall_slide")
func flip():
	if not is_on_wall_only():
		if velocity.x >0:
			anim.flip_h= false
			facing_right = true
		if velocity.x<0:
			facing_right = false
			anim.flip_h=true
	elif is_on_wall_only():
		if right.is_colliding():
			anim.flip_h = true
		elif left.is_colliding():
			anim.flip_h= false
func jump_logic():
	if is_on_floor():
		jump_amount = 2
		if Input.is_action_just_pressed("Jump"):
			jump_amount-=1
			velocity.y -= lerp(jump_speed, acceleration, 0.1)
			anim.play("Jump")
	if not is_on_floor():
		if jump_amount>=0:
			if Input.is_action_just_pressed("Jump"):
				velocity.y -= lerp(jump_speed, acceleration, 1)
				anim.play("Jump")
			if Input.is_action_just_released("Jump"):
				velocity.y = lerp(velocity.y, gravity, 0.2)
				velocity.y *=0.3
				jump_amount -= 1
	else:
		return
func wall_logic():
	if is_on_wall_only():
		velocity.y = 10
		if Input.is_action_just_pressed("Jump"):
			if left.is_colliding():
				velocity= Vector2(wall_x_force,wall_y_force)
				anim.flip_h = true
			if right.is_colliding():
				velocity = Vector2(-wall_x_force, wall_y_force)
				anim.flip_h = false
func wall_jumping():
	is_wall_jumping = true
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false
func dash():
	if dash_key_pressed ==1:
		is_dashing = true
	else:
		is_dashing = false
	if facing_right == true:
		velocity.x= dash_speed
		dash_started()
	if facing_right==false:
		velocity.x = -dash_speed
		dash_started()
func dash_started():
	if is_dashing == true:
		dash_key_pressed = 1
		await get_tree().create_timer(0.3).timeout
		is_dashing = false
		dash_key_pressed = 0
	else:
		return
