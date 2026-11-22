extends Area2D

@export var speed: float = 600.0
@export var damage: float = 25.0
@export var element_type: String = "none"
@onready var sprite: Sprite2D = $Sprite2D

# Different bullet effects
var knockback: bool = false
var piercing: bool = false
var aoe: bool = false
var splits: bool = false
var stun_chance: float = 0.0
var is_split_child: bool = false

var direction: Vector2 = Vector2.RIGHT

# Checks for collisions and makes bullets disappear after 1s lifetime
func _ready() -> void:
	if Inventory.selected_ammo != "None":
		sprite.texture = load(Inventory.ammo_images[Inventory.selected_ammo])
	else:
		sprite.texture = load('res://Art/stone.png')
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

# Tomato ability
func _trigger_aoe_explosion() -> void:
	# Gets state space to find nearby enemies
	var space_state = get_world_2d().direct_space_state
	
	# Set up rules for spacias search - circle radius of 4 tiles
	var query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 64.0
	query.shape = circle
	
	# Match center to bullet position
	query.transform = global_transform
	
	# Creates array containing each physics body overlapping the circle
	var results = space_state.intersect_shape(query)
	for hit in results:
		var target = hit.collider
		if target.is_in_group("enemies") and target.has_method("take_damage"):
			target.take_damage(damage * 0.5, element_type) 

# Corn ability
func _trigger_seed_split() -> void:
	var angles = [-0.4, 0.0, 0.4] # Direction for each split child
	for angle in angles: # For each child, create a new bullet scene
		var shrapnel = load("res://scenes/bullet.tscn").instantiate()
		# Offset spawn in direction of split (so that it doesn't 
		# collide with the enemy it is splitting from)
		shrapnel.global_position = global_position + (direction.rotated(angle) * 30)
		shrapnel.direction = direction.rotated(angle)
		shrapnel.rotation = shrapnel.direction.angle()
		shrapnel.damage = damage * 0.4
		shrapnel.speed = speed * 0.8
		# So that it doesn't split again
		shrapnel.is_split_child = true 
		get_tree().current_scene.call_deferred("add_child", shrapnel)
		
