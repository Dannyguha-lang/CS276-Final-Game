extends EnemyBase
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()   
	attack_range = 100
	attack_cooldown = 2.0 
	setAttackTimer() 


	
