extends CharacterBody2D

@export var speed := 220.0
@export var jump_force := -430.0
@export var gravity := 1000.0
@export var wall_jump := Vector2(320, -420)

@onready var floor_check: RayCast2D = $FloorCheck
@onready var wall_left: RayCast2D = $WallCheckLeft
@onready var wall_right: RayCast2D = $WallCheckRight

func _physics_process(delta):
	apply_gravity(delta)
	player_movement()
	move_and_slide()

func apply_gravity(delta):
	if not floor_check.is_colliding():
		velocity.y += gravity * delta

func player_movement():
	var dir = Input.get_axis("p1_left", "p1_right")
	velocity.x = dir * speed

	# SALTO NORMAL
	if Input.is_action_just_pressed("p1_jump") and floor_check.is_colliding():
		velocity.y = jump_force

	# WALL JUMP IZQUIERDO
	if Input.is_action_just_pressed("p1_jump") and wall_left.is_colliding():
		velocity = wall_jump
		velocity.x = abs(wall_jump.x)

	# WALL JUMP DERECHO
	if Input.is_action_just_pressed("p1_jump") and wall_right.is_colliding():
		velocity = wall_jump
		velocity.x = -abs(wall_jump.x)
