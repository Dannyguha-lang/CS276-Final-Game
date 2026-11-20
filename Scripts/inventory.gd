extends PanelContainer

@onready var itemView = $InventoryContainer/InventoryPanels/CenterContainer
@onready var rows = $InventoryContainer/InventoryPanels/InventoryRows
@onready var buttons = $InventoryContainer/InventoryButtons

@export var row_width = 4
var currentItem = "None"
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		buildInventory("seeds")
		toggleInventory()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	itemView.changeItem("None","None","None","None")
	var types = ["seeds","ammo","weapons","fish"]
	for t in types:
		var button = Button.new()
		button.text = t
		button.pressed.connect(func(): buildInventory(t))
		buttons.add_child(button)

func toggleInventory():
	visible = not visible


func buildInventory(type:String):
	if itemView.visible:
		itemView.changeItem("None","None","None","None")
	for row in rows.get_children():
		row.queue_free()
	var amounts
	var images
	match type:
		"seeds":
			amounts = Inventory.seeds
			images = Inventory.seed_images
			pass
		"ammo":
			amounts = Inventory.ammo
			images = Inventory.ammo_images
			pass
		"weapons":
			amounts = Inventory.weapons
			pass	
		"fish":
			amounts = Inventory.weapons
			pass	
	var row
	var x = 0
	for k in amounts:
		if x % row_width == 0:
			if row:
				rows.add_child(row)
			row = HBoxContainer.new()
			
		var button = Button.new()
		var image = TextureRect.new()
		var text = Label.new()
		var amount = Label.new()
		var box = VBoxContainer.new()
		
		image.texture = load(images[k])
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.custom_minimum_size = Vector2(32, 32)
		image.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		
		text.text = k
		amount.text = str(amounts[k])
		text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		amount.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		box.alignment = BoxContainer.ALIGNMENT_CENTER

		button.pressed.connect(func(): itemView.changeItem(text.text, image.texture, amount.text, 1))
		
		box.add_child(image)
		box.add_child(text)
		box.add_child(amount)
		button.add_child(box)
		button.custom_minimum_size = Vector2(96, 96)
		row.add_child(button)
		
		x +=1
	
