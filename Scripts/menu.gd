extends PanelContainer

@onready var day: PackedScene = preload("res://Scenes/day.tscn")

@onready var start: Button = $MarginContainer/VBoxContainer/Start
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit
@onready var select_difficulty: Button = $MarginContainer/VBoxContainer/Difficulty

func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(_on_quit_pressed)
	select_difficulty.item_selected.connect(setDifficulty)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(day)

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func setDifficulty(i):
	Difficulty.setDifficulty(select_difficulty.get_item_text(i))
