extends Area2D

@export var speed: float = 600.0
@export var damage: float = 25.0
@export var element_type: String = "none"

# Different bullet effects
var knockback: bool = false
var piercing: bool = false
var aoe: bool = false
var splits: bool = false
var stun_chance: float = 0.0
var is_split_child: bool = false

var direction: Vector2 = Vector2.RIGHT

# Temporary - draws bullet types as different colored circles
func _draw() -> void:
	var bullet_color := Color("ffffff") 
	
	match element_type:
		"fire": bullet_color = Color("ff4500") 
		"water": bullet_color = Color("1e90ff")  
		"poison": bullet_color = Color("9370db")  
		"earth": bullet_color = Color("8b4513")  

	if knockback: bullet_color = Color("ff8c00") 
	if piercing: bullet_color = Color("ffeb3b") 
	if aoe: bullet_color = Color("e91e63") 
	if splits: bullet_color = Color("d81b60")
	if stun_chance > 0.0: bullet_color = Color("795548")

	draw_circle(Vector2.ZERO, 6.0, bullet_color)

# Checks for collisions and makes bullets disappear after 1s lifetime
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	get_tree().create_timer(1.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

 # Collision check
func _on_body_entered(body: Node2D) -> void:
	# Ensures hit body is a character and enemy
	if body is CharacterBody2D and not body.is_in_group("enemies"):
		return
	print("body hit ", body.name)
	# Different bullet effects on enemies
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage, element_type)
	
		if knockback and body.has_method("apply_knockback"):
			body.apply_knockback(direction * 300)
		
		# This makes it so that the bullet isn't removed from the queue on hit
		if piercing:
			return
		# Generates a random num 0 - 1 and checks if it's below the stun chance	
		if stun_chance > 0 and randf() < stun_chance:
			if body.has_method("apply_stun"):
				body.apply_stun(1.0)
	
	if aoe:
		_trigger_aoe_explosion()
	
	# Makes it so the children of a split bullet don't continue to split
	if splits and not is_split_child:
		_trigger_seed_split()		
	queue_free()

func _trigger_aoe_explosion() -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 64.0
	query.shape = circle
	query.transform = global_transform
	
	var results = space_state.intersect_shape(query)
	for hit in results:
		var target = hit.collider
		if target.is_in_group("enemies") and target.has_method("take_damage"):
			target.take_damage(damage * 0.5, element_type) 

func _trigger_seed_split() -> void:
	var angles = [-0.4, 0.0, 0.4] 
	for angle in angles:
		var shrapnel = load("res://scenes/bullet.tscn").instantiate()
		shrapnel.global_position = global_position + (direction.rotated(angle) * 30)
		shrapnel.direction = direction.rotated(angle)
		shrapnel.rotation = shrapnel.direction.angle()
		shrapnel.damage = damage * 0.4
		shrapnel.speed = speed * 0.8
		shrapnel.is_split_child = true 
		get_tree().current_scene.call_deferred("add_child", shrapnel)
		
