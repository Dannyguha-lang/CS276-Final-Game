extends EnemyBase

func _ready() -> void:
	attack_range = 200
	attack_cooldown = 2.0
	projectile_scene = preload("res://Scenes/spider_projectile.tscn")
	super()

	
