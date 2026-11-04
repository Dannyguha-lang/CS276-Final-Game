extends Node
var battle_stats:Dictionary = {"Max Health":100,"Regen":0.5,"Speed":500,"Drop Chance":0.05}
var fishing_stats:Dictionary = {"Harvest Speed":1.0,"Harvest Luck":1.0}
var farming_stats:Dictionary = {"Fishing Speed":1.0,"Fishing Luck":1.0,"Equipment Luck":0.05}
var current_health:float = 0.00
var equipped_weapon = "None"

# Called when the node enters the scene tree for the first time.
func takeDamage(num:int):
	current_health -= num
	

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
