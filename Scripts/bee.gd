extends EnemyBase
# Called when the node enters the scene tree for the first time.
var mode = "flight"


func _ready() -> void:
	attack_range = 100
	attack_cooldown = 0
	super()   
	element = "poison"

func attack():
	if target and mode == "flight":
		speed *= 3
		attack_range = 10
		mode = "attack"
		nav.target_desired_distance = attack_range
	elif target and mode == "attack":
		#target.takeDamage(damage,element)
		die()
		
