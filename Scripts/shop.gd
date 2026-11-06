extends PanelContainer


const upgrades:Dictionary = {"Max Health":{"maxLevel":10,"effect":20,"initialCost":10,"costMult":1.5},"Speed":{"maxLevel":5,"effect":5,"initialCost":50,"costMult":2},"Luck":{"maxLevel":15,"effect":0.01,"initialCost":10,"costMult":1.25},"Regen":{"maxLevel":5,"effect":1,"initialCost":50,"costMult":1.5}}
var current_levels:Dictionary = {"Max Health":0,"Speed":0,"Luck":0,"Regen":0,}
@onready var shop_list = $ShopList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buildShop()
	hide()
		
func closeShop():
	hide()

func openShop():
	show()

func buyUpgrade(id):
	var money = Inventory.getCoins()
	print(id)
	if id not in upgrades:
		return false
	var upgrade = upgrades[id]
	if current_levels[id] >= upgrade["maxLevel"]:
		return false
	var cost = upgrade["initialCost"] + (upgrade["initialCost"] * upgrade["costMult"] * current_levels[id])
	if money <= cost :
		return false
	Inventory.updateCoins(cost * -1)
	current_levels[id] += 1
	Player.increaseBattleStat(id,upgrade["effect"])
	buildShop()
	return true

	
func buildShop():
	for child in shop_list.get_children():
		#Delete any current items
		child.queue_free()
	for i in upgrades:
		var upgrade = upgrades[i]
		var button = Button.new()
		button.text = "%s Upgrade %s / %s. Cost: £ %s" % [i,current_levels[i],upgrade["maxLevel"],upgrade["initialCost"] + (upgrade["initialCost"] * upgrade["costMult"] * current_levels[i])]
		button.pressed.connect(buyUpgrade.bind(i))
		if current_levels[i] >= upgrade["maxLevel"]:
			button.disabled = true
		shop_list.add_child(button)
