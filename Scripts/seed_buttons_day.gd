extends VBoxContainer

func updateType(type,num):
	var node = get_node(type)
	if node:
		node.get_node("ButtonContents/Label").text = str(num)
	
func chooseSeed(type):
	if type in Inventory.seeds and Inventory.seeds[type] > 0:
		Inventory.selected_seed = type

		
func _ready() -> void:
	$tomato.pressed.connect(chooseSeed.bind("tomato"))
	$cucumber.pressed.connect(chooseSeed.bind("cucumber"))
	$corn.pressed.connect(chooseSeed.bind("corn"))
	$pumpkin.pressed.connect(chooseSeed.bind("pumpkin"))
	$onion.pressed.connect(chooseSeed.bind("onion"))
	$chilli.pressed.connect(chooseSeed.bind("chilli"))
	$radish.pressed.connect(chooseSeed.bind("radish"))
	$potato.pressed.connect(chooseSeed.bind("potato"))
	$carrot.pressed.connect(chooseSeed.bind("carrot"))
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('tomato'):
		chooseSeed("tomato")
	elif event.is_action_pressed('cucumber'):
		chooseSeed("cucumber")
	elif event.is_action_pressed('corn'):
		chooseSeed("corn")
	elif event.is_action_pressed('pumpkin'):
		chooseSeed("pumpkin")
	elif event.is_action_pressed('chilli'):
		chooseSeed("chilli")
	elif event.is_action_pressed('onion'):
		chooseSeed("onion")
	elif event.is_action_pressed('radish'):
		chooseSeed("radish")
	elif event.is_action_pressed('potato'):
		chooseSeed("potato")
	elif event.is_action_pressed('carrot'):
		chooseSeed("carrot")
