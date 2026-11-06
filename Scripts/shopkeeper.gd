extends CharacterBody2D

var shop_open = false
@onready var player = get_node("../Player")
@onready var shop = get_node("../UI/UIRoot/Shop")
func _process(delta: float) -> void:
	if position.distance_to(player.position) <= 80 and not shop_open:
		shop_open = true
		shop.openShop()
	elif position.distance_to(player.position) > 80 and shop_open:
		shop_open = false
		shop.closeShop()
