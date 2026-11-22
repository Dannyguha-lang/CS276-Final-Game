extends Node2D

@onready var timer = $Timer

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = 30
	timer.timeout.connect(turnDay)
	$EnemySpawner.startTimer()
	timer.start()
	

func turnDay():
	Inventory.addCycle()
	print(Inventory.current_cycle)
	$EnemySpawner.stopTimer()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	get_tree().change_scene_to_file("res://Scenes/day.tscn")
	
