extends CharacterBody2D

# =============================
# MOVIMIENTO
# =============================
@export var speed := 220.0
@export var jump_force := -260.0
@export var gravity := 1000.0
@export var wall_jump_force := Vector2(260, -320)

# =============================
# REFERENCIAS
# =============================
@onready var floor_check: RayCast2D = $FloorCheck
@onready var wall_left: RayCast2D = $WallCheckLeft
@onready var wall_right: RayCast2D = $WallCheckRight

# TileMap de trampas (está en la escena del nivel)
var traps_tilemap: TileMapLayer

# UI (Game Manager)
var ui: CanvasLayer

# =============================
# ESTADO
# =============================
var start_position: Vector2
var can_take_damage := true

# =============================
# READY
# =============================
func _ready():
	start_position = global_position

	# Buscar UI (GameManager)
	ui = get_tree().get_first_node_in_group("ui")

	# Buscar TileMap de trampas en la escena
	traps_tilemap = get_tree().get_first_node_in_group("traps")

# =============================
# PHYSICS
# =============================
func _physics_process(delta):
	apply_gravity(delta)
	handle_movement()
	handle_jump()
	handle_wall_jump()

	move_and_slide()

	check_traps_damage()

# =============================
# GRAVEDAD
# =============================
func apply_gravity(delta):
	if not floor_check.is_colliding():
		velocity.y += gravity * delta

# =============================
# MOVIMIENTO HORIZONTAL
# =============================
func handle_movement():
	var dir = Input.get_axis("p1_left", "p1_right")
	velocity.x = dir * speed

# =============================
# SALTO NORMAL
# =============================
func handle_jump():
	if Input.is_action_just_pressed("p1_jump") and floor_check.is_colliding():
		velocity.y = jump_force

# =============================
# WALL JUMP
# =============================
func handle_wall_jump():
	if not Input.is_action_just_pressed("p1_jump"):
		return

	if wall_left.is_colliding():
		velocity.y = wall_jump_force.y
		velocity.x = abs(wall_jump_force.x)

	elif wall_right.is_colliding():
		velocity.y = wall_jump_force.y
		velocity.x = -abs(wall_jump_force.x)

# =============================
# DETECCIÓN DE TRAMPAS
# =============================
func check_traps_damage():
	if traps_tilemap == null:
		return

	# Convertir posición del jugador a local del tilemap
	var local_pos: Vector2 = traps_tilemap.to_local(global_position)
	var cell: Vector2i = traps_tilemap.local_to_map(local_pos)

	# Layer 2 = trampas
	var tile_id: int = traps_tilemap.get_cell_source_id(cell)

	# Si hay tile (no -1), es una trampa
	if tile_id != -1:
		take_damage()

# =============================
# DAÑO
# =============================
func take_damage():
	if not can_take_damage:
		return

	can_take_damage = false

	if ui:
		ui.damage_player(self)

	# Pequeña invulnerabilidad
	await get_tree().create_timer(0.8).timeout
	can_take_damage = true

# =============================
# RESPAWN
# =============================
func reset_to_start():
	global_position = start_position
	velocity = Vector2.ZERO
