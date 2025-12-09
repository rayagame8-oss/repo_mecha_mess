extends CharacterBody2D

@onready var hearts = $Hearts
@onready var spikes_tilemap = $SpikesTileMap  # TileMap que contiene las espinas

@export var max_health := 3
var health := max_health

@export var hearts_3: Texture2D
@export var hearts_2: Texture2D
@export var hearts_1: Texture2D
@export var hearts_0: Texture2D

@export var speed := 200.0

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized() * speed
	
	velocity = input_vector
	move_and_slide()
	
	check_spikes()

func check_spikes():
	# Convierte la posición del jugador en coordenadas de celda del TileMap
	var cell_pos = spikes_tilemap.world_to_map(global_position)
	var tile_id = spikes_tilemap.get_cellv(cell_pos)
	
	if tile_id != -1:  # Si hay un tile en esa celda
		take_damage(1)
		spikes_tilemap.set_cellv(cell_pos, -1)  # Elimina el tile para que no haga daño otra vez

func take_damage(amount: int):
	health -= amount
	health = clamp(health, 0, max_health)
	update_hearts()
	
	if health <= 0:
		die()

func update_hearts():
	match health:
		3:
			hearts.texture = hearts_3
		2:
			hearts.texture = hearts_2
		1:
			hearts.texture = hearts_1
		0:
			hearts.texture = hearts_0

func die():
	queue_free()  # O cualquier otra lógica de muerte
