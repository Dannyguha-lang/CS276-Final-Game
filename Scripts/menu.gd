extends PanelContainer

@onready var day: PackedScene = preload("res://Scenes/day.tscn")

@onready var start: Button = $MarginContainer/VBoxContainer/Start
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit

func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(day)

func _on_quit_pressed() -> void:
	get_tree().quit()
