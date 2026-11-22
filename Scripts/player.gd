extends CharacterBody2D

# Player movement speed and the area the player can walk in.
@export var SPEED = 220.0
const MIN_POS = Vector2(54, 95)
const MAX_POS = Vector2(970, 590)

@export var max_health: float = 100.0
var health: float = 100.0

@export var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@export var fire_rate: float = 0.20

var fire_cooldown: float = 0.0
var active_seed_ability: String = "normal"
var is_night: bool = false

func _physics_process(delta: float) -> void:
	# Godot's arrow-key input actions.
	var direction = Vector2.ZERO

	# Also allow the WASD keys.
	var wasd = Vector2.ZERO
	if Input.is_key_pressed(KEY_A):
		wasd.x -= 1
	if Input.is_key_pressed(KEY_D):
		wasd.x += 1
	if Input.is_key_pressed(KEY_W):
		wasd.y -= 1
	if Input.is_key_pressed(KEY_S):
		wasd.y += 1
	if wasd != Vector2.ZERO:
		direction = wasd.normalized()

	velocity = direction * SPEED
	move_and_slide()
	global_position = global_position.clamp(MIN_POS, MAX_POS)
	
	if fire_cooldown > 0:
		fire_cooldown -= delta

	if is_night and Input.is_action_pressed("shoot") and fire_cooldown <= 0:
		shoot()
		
func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return

	if event.is_action_pressed("select_normal"):
		active_seed_ability = "normal"
		get_tree().current_scene._notify("Normal ammo - Unlimited!")
		return
		
	match event.keycode:
		KEY_1:
			active_seed_ability = "normal"
		KEY_2:
			active_seed_ability = "chilli"
		KEY_3:
			active_seed_ability = "pumpkin"
		KEY_4:
			active_seed_ability = "carrot"
		KEY_5:
			active_seed_ability = "cucumber"
		KEY_6:
			active_seed_ability = "mushroom"
		KEY_7:
			active_seed_ability = "tomato"
		KEY_8:
			active_seed_ability = "pomegranate"
		KEY_9:
			active_seed_ability = "potato"
		KEY_0:
			active_seed_ability = "walnut"
		
	
func shoot() -> void:
	if bullet_scene == null:
		return
		
	var current_ammo = Inventory.selected_ammo
	
	if not Inventory.useAmmo(current_ammo, 1):
		return

	var game = get_tree().current_scene

	fire_cooldown = fire_rate

	var bullet = bullet_scene.instantiate()

	_apply_ability_modifier(bullet)

	var target_dir = (get_global_mouse_position() - global_position).normalized()

	game.add_child(bullet)

	bullet.global_position = global_position
	bullet.direction = target_dir
	bullet.rotation = target_dir.angle()
	
func _apply_ability_modifier(bullet: Node2D) -> void:
	bullet.element_type = "none"
	bullet.knockback = false
	bullet.piercing = false
	bullet.aoe = false
	bullet.splits = false
	bullet.stun_chance = 0.0
	
	match active_seed_ability:
		"pumpkin":
			bullet.element_type = "none"
			bullet.damage = 25.0
			if "knockback" in bullet:
				bullet.knockback = true
		"carrot":
			bullet.element_type = "none"
			bullet.damage = 15.0
			if "piercing" in bullet:
				bullet.piercing = true
		"cucumber":
			bullet.element_type = "water"
			bullet.damage = 25.0
		"radish":
			bullet.element_type = "poison"
			bullet.damage = 25.0
		"tomato":
			bullet.element_type = "none"
			bullet.damage = 12.5
			if "aoe" in bullet:
				bullet.aoe = true
		"corn":
			bullet.element_type = "none"
			bullet.damage = 7.5
			if "splits" in bullet:
				bullet.splits = true
		"chilli":
			bullet.element_type = "fire"
			bullet.damage = 25.0
		"onion":
			bullet.element_type = "none"
			bullet.damage = 15.0
			if "stun_chance" in bullet:
				bullet.stun_chance = 0.5
		"potato":
			bullet.element_type = "earth"
			bullet.damage = 25.0
		"normal", _:
			bullet.element_type = "none"
			bullet.damage = 15.0

func take_damage(amount: float,element:String) -> void:

	health = max(health - amount, 0.0)

	var message = "OUCH! -%d HP  |  HP: %d/%d" % [
		int(amount),
		int(health),
		int(max_health)
	]

	get_tree().current_scene._notify(message)

	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout

	if not is_inside_tree():
		return

	modulate = Color.WHITE

	if health <= 0:
		die()

func die() -> void:
	get_tree().current_scene._notify("GAME OVER! Player died!")
	set_physics_process(false)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
