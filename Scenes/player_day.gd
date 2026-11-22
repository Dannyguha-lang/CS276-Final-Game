extends CharacterBody2D

@export var SPEED = 220.0
const MIN_POS = Vector2(54, 95)
const MAX_POS = Vector2(970, 590)

func _ready() -> void:
	add_to_group("player")
	if Player.has_saved_position:
		global_position = Player.saved_position

func _physics_process(delta: float) -> void:
	var wasd = Vector2.ZERO
	if Input.is_key_pressed(KEY_A):
		wasd.x -= 1
	if Input.is_key_pressed(KEY_D):
		wasd.x += 1
	if Input.is_key_pressed(KEY_W):
		wasd.y -= 1
	if Input.is_key_pressed(KEY_S):
		wasd.y += 1

	velocity = wasd.normalized() * SPEED if wasd != Vector2.ZERO else Vector2.ZERO
	move_and_slide()
	global_position = global_position.clamp(MIN_POS, MAX_POS)

func _exit_tree() -> void:
	Player.saved_position = global_position
	Player.has_saved_position = true
