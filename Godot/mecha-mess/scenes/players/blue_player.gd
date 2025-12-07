extends CharacterBody2D

@export var speed := 220.0
@export var jump_force := -220.0
@export var gravity := 1000.0
@export var wall_jump := Vector2(220, -320)

@onready var floor_check: RayCast2D = $FloorCheck
@onready var wall_left: RayCast2D = $WallCheckLeft
@onready var wall_right: RayCast2D = $WallCheckRight

func _physics_process(delta):
	# MOVIMIENTO HORIZONTAL
	var dir = Input.get_axis("p1_left", "p1_right")
	velocity.x = dir * speed

	# GRAVEDAD
	if not floor_check.is_colliding():
		velocity.y += gravity * delta

	# SALTO NORMAL
	if Input.is_action_just_pressed("p1_jump") and floor_check.is_colliding():
		velocity.y = jump_force

	# WALL JUMP IZQUIERDA
	if Input.is_action_just_pressed("p1_jump") and wall_left.is_colliding():
		velocity = wall_jump
		velocity.x = abs(wall_jump.x)

	# WALL JUMP DERECHA
	if Input.is_action_just_pressed("p1_jump") and wall_right.is_colliding():
		velocity = wall_jump
		velocity.x = -abs(wall_jump.x)

	move_and_slide()
