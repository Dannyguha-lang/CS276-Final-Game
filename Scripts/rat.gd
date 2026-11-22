extends EnemyBase

func _ready() -> void:
	super()
	attack_range = 36
	
	setAttackTimer()
