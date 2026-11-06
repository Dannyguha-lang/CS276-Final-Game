extends Node
var coins: int = 0
var seeds: Dictionary = {"tomato":0,"cucumber":0,"corn":0,"pumpkin":0,"onion":0,"chilli":0,"radish":0,"potato":0,"carrot":0}
var seed_images: Dictionary = {"tomato":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/01_tomato/tomato_seeds_icon.png","cucumber":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/02_cucumber/cucumber_seeds_icon.png","corn":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/04_corn/corn_seeds_icon.png","pumpkin":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/05_pumpkin/pumpkin_seeds_icon.png","onion":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/08_onion/onion_seeds_icon.png","chilli":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/10_red_chili/red_chili_seeds_icon.png","radish":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/13_purple_radish/purple_radish_seeds_icon.png","potato":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/14_potato/potato_seeds_icon.png","carrot":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/17_carrot/carrot_seeds_icon.png"}
var ammo: Dictionary = {"tomato":0,"cucumber":0,"corn":0,"pumpkin":0,"onion":0,"chilli":0,"radish":0,"potato":0,"carrot":0}
var ammo_images: Dictionary = {"tomato":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/01_tomato/tomato_produce_normal.png","cucumber":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/02_cucumber/cucumber_produce_normal.png","corn":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/04_corn/corn_produce_golden.png","pumpkin":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/05_pumpkin/pumpkin_produce_golden.png","onion":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/08_onion/onion_produce_normal.png","chilli":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/10_red_chili/red_chili_produce_normal.png","radish":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/13_purple_radish/purple_radish_produce_normal.png","potato":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/14_potato/potato_produce_normal.png","carrot":"res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16/17_carrot/carrot_produce_normal.png"}
var sell_values: Dictionary = {"tomato":10,"cucumber":10,"corn":10,"pumpkin":10,"onion":10,"chilli":10,"radish":10,"potato":10,"carrot":10}
var weapons:Array = []
# Called when the node enters the scene tree for the first time.

func addSeeds(type:String,number:int) -> bool:
	if type not in seeds:
		return false
	seeds[type] += number
	return true
	
func useSeeds(type:String,number:int) -> bool:
	if type not in seeds:
		return false
	if seeds[type] < number:
		return false
	seeds[type] -= number
	return true

func sellSeeds(type:String,number:int) -> bool:
	if type not in sell_values:
		return false
	if useSeeds(type,number):
		coins += sell_values[type]
		return true
	return false


func _ready() -> void:
	pass # Replace with function body.

func getCoins():
	return coins

func updateCoins(amount):
	coins += amount
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
