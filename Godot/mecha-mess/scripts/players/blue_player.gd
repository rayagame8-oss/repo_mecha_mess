extends CharacterBody2D

enum State { NORMAL, WALL_JUMP }

@export var speed := 230.0
@export var jump_force := -450.0
@export var gravity := 950.0
@export var wall_jump := Vector2(300, -430)

# Cooperativo
@export var player_id := 1
@export var blue_surface := "blue_surface"

@onready var wall = $WallCheck

var state = State.NORMAL

func _physics_process(delta):
	apply_gravity(delta)
	apply_state()
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func apply_state():
	match state:
		State.NORMAL:
			normal()
		State.WALL_JUMP:
			wall_jump_state()

func normal():
	var left = "p%d_left" % player_id
	var right = "p%d_right" % player_id
	var jump = "p%d_jump" % player_id
	
	var dir = Input.get_axis(left, right)
	velocity.x = dir * speed

	if Input.is_action_just_pressed(jump) and is_on_floor():
		velocity.y = jump_force

	if wall.is_colliding():
		var c = wall.get_collider()
		if c.is_in_group(blue_surface) and Input.is_action_just_pressed(jump):
			state = State.WALL_JUMP

func wall_jump_state():
	velocity = wall_jump
	state = State.NORMAL
