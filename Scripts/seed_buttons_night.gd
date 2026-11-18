extends VBoxContainer
var collapsed = false
func updateType(type,num):
	var node = get_node(type)
	if node:
		node.get_node("ButtonContents/Label").text = str(num)


func chooseAmmo(type):
	if type in Inventory.ammo and Inventory.ammo[type] > 0:
		Inventory.selected_ammo = type


func ExpandCollapse():
	if collapsed:
		for type in Inventory.ammo:
			var node = get_node(type)
			if Inventory.ammo[type] <= 0:
				node.disabled = true
			else:
				node.disabled = false
			if type != Inventory.selected_ammo:
				node.hide()
			else:
				node.show()
	else:
		for type in Inventory.ammo:
			var node = get_node(type)
			if Inventory.ammo[type] <= 0:
				node.disabled = true
			else:
				node.disabled = false
			node.show()

func ExpandCollapsePress():
	collapsed = not collapsed
	ExpandCollapse()
	if collapsed:
		$Panel/VBox/ExpandCollapse.text = "↓"
	else:
		$Panel/VBox/ExpandCollapse.text = "↑"
	
	
			
	
func _ready() -> void:
	$tomato.pressed.connect(chooseAmmo.bind("tomato"))
	$cucumber.pressed.connect(chooseAmmo.bind("cucumber"))
	$corn.pressed.connect(chooseAmmo.bind("corn"))
	$pumpkin.pressed.connect(chooseAmmo.bind("pumpkin"))
	$onion.pressed.connect(chooseAmmo.bind("onion"))
	$chilli.pressed.connect(chooseAmmo.bind("chilli"))
	$radish.pressed.connect(chooseAmmo.bind("radish"))
	$potato.pressed.connect(chooseAmmo.bind("potato"))
	$carrot.pressed.connect(chooseAmmo.bind("carrot"))
	$Panel/VBox/ExpandCollapse.pressed.connect(ExpandCollapsePress)
	ExpandCollapse()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('tomato'):
		chooseAmmo("tomato")
	elif event.is_action_pressed('cucumber'):
		chooseAmmo("cucumber")
	elif event.is_action_pressed('corn'):
		chooseAmmo("corn")
	elif event.is_action_pressed('pumpkin'):
		chooseAmmo("pumpkin")
	elif event.is_action_pressed('chilli'):
		chooseAmmo("chilli")
	elif event.is_action_pressed('onion'):
		chooseAmmo("onion")
	elif event.is_action_pressed('radish'):
		chooseAmmo("radish")
	elif event.is_action_pressed('potato'):
		chooseAmmo("potato")
	elif event.is_action_pressed('carrot'):
		chooseAmmo("carrot")
