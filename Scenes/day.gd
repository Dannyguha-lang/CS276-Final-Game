extends Node2D

@onready var timer = $Timer

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = 1
	timer.timeout.connect(turnNight)
	timer.start()

func turnNight():
	get_tree().change_scene_to_file("res://Scenes/night.tscn")
	
