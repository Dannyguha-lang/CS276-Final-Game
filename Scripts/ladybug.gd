extends EnemyBase

func _ready() -> void:
	max_health = 30.0
	speed = 35.0
	damage = 8.0
	element = "none" 
	attack_range = 36.0
	attack_cooldown = 2.0
	super()
	setAttackTimer()
