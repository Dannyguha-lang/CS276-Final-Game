extends CharacterBody2D
var game_open = false
@onready var main = get_tree().current_scene
@onready var player = get_node("../Player")
@onready var game = get_node("../UI/UIRoot/FishingMinigame")
func _process(delta: float) -> void:
	if position.distance_to(player.position) <= 80 and not game_open:
		game_open = true
		game.start()
	elif position.distance_to(player.position) > 80 and game_open:
		game_open = false
		game.end()
