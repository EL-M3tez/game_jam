extends Character1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: RayCast2D = $Attack_range
const speed = 35
const gravity = 500
const MIN_DISTANCE_TO_NEXT_POINT = 5

@export var player: Character1
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	if player:
		makepath()
	else:
		print("Player node not assigned to the enemy!")

func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("Walk")
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("Walk")
	else:
		animated_sprite_2d.play("Idle")
	# Apply gravity
	velocity.y += gravity * delta
	if attack_range.is_colliding():
		animated_sprite_2d.play("Attack")
		player.health -= damage
	if player:
		nav_agent.target_position = player.global_position
	

	var next_point = nav_agent.get_next_path_position()
	
	if global_position.distance_to(next_point) > MIN_DISTANCE_TO_NEXT_POINT:
		var dir = global_position.direction_to(next_point)
		velocity.x = dir.x * speed
	else:
		velocity.x = 0
	
	move_and_slide()

func makepath() -> void:
	nav_agent.target_position = player.global_position
