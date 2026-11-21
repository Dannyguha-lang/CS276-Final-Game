extends Node2D

@onready var timer = $Timer

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = 120
	timer.timeout.connect(turnDay)
	$EnemySpawner.startTimer()
	timer.start()

func turnDay():
	Inventory.addCycle()
	$EnemySpawner.stopTimer()
	get_tree().change_scene_to_file("res://Scenes/day.tscn")
	
