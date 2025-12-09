extends CanvasLayer

@onready var hearts = $Hearts

# Vida compartida
@export var max_health := 3
var health := 3

# Sprites de corazones
@export var hearts_3: Texture2D
@export var hearts_2: Texture2D
@export var hearts_1: Texture2D
@export var hearts_0: Texture2D

# Checkpoint
var checkpoint_position := Vector2.ZERO

func _ready():
	print("UI / GAME MANAGER ACTIVO")
	health = max_health
	update_hearts()


# === SISTEMA DE DAÑO ===
func damage_player(player_node):
	health -= 1
	health = clamp(health, 0, max_health)
	update_hearts()

	print("VIDA ACTUAL:", health)

	if health <= 0:
		game_over()
	else:
		respawn_player(player_node)


# === ACTUALIZAR UI ===
func update_hearts():
	if not hearts:
		return

	match health:
		3:
			hearts.texture = hearts_3
		2:
			hearts.texture = hearts_2
		1:
			hearts.texture = hearts_1
		0:
			hearts.texture = hearts_0


# === RESPAWN ===
func respawn_player(player_node):
	if checkpoint_position != Vector2.ZERO:
		player_node.global_position = checkpoint_position
	else:
		player_node.global_position = player_node.start_position


# === CHECKPOINT ===
func set_checkpoint(pos: Vector2):
	checkpoint_position = pos
	print("Checkpoint guardado en:", checkpoint_position)


# === GAME OVER ===
func game_over():
	print("GAME OVER")
	get_tree().reload_current_scene()
