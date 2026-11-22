extends EnemyBase
# Called when the node enters the scene tree for the first time.


func _ready() -> void: 
	speed = 0
	attack_range = 1000
	attack_cooldown = 2.0
	element = "water"
	super()  
