extends EnemyBase
# Called when the node enters the scene tree for the first time.


func _ready() -> void: 
	speed = 0
	attack_range = 1000
	attack_cooldown = 2.0
	element = "water"
	projectile_scene = preload("res://Scenes/fish_projectile.tscn")
	super()  
	
func behave() -> void:
	velocity = Vector2.ZERO
