extends PanelContainer

@onready var itemView = $InventoryPanels/InventoryItemView
@onready var rows = $InventoryPanels/InventoryRows
@onready var main = get_parent().get_parent()

@export var row_width = 4
var currentItem = "None"
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		buildInventory("seed")
		toggleInventory()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	itemView.changeItem("None","None","None","None")

func toggleInventory():
	visible = not visible


func buildInventory(type:String):
	for row in rows.get_children():
		row.queue_free()
	var values
	var images
	match type:
		"seed":
			values = Inventory.seeds
			images = Inventory.seed_images
			pass
		"ammo":
			values = Inventory.ammo
			images = Inventory.ammo_images
			pass
		"weapons":
			values = Inventory.weapons
			pass		
	var row
	var x = 0
	for k in values:
		if x % row_width == 0:
			rows.add_child(row)
			row = HBoxContainer.new()
			
		var button = Button.new()
		var image = TextureRect.new()
		var text = Label.new()
		var amount = Label.new()
		var box = VBoxContainer.new()
		
		image.texture = load(images[k])
		text.text = k
		amount.text = str(values[k])
		button.pressed.connect(func(): itemView.changeItem(text.text, image.texture, amount.text, 1))
		box.add_child(image)
		box.add_child(text)
		box.add_child(amount)
		button.add_child(box)
		button.custom_minimum_size = Vector2(96, 96)
		row.add_child(button)
		
		x +=1
	
