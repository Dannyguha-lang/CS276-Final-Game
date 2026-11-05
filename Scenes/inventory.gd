extends PanelContainer


@onready var itemView = $InventoryPanels/InventoryItemView
@onready var row = $InventoryPanels/InventoryRows/InventoryRow1
@onready var main = get_parent().get_parent()

var currentItem = "None"
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		buildInventory()
		toggleInventory()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	itemView.changeItem("None","None","None","None")
	var labels = ["Corn","Corn Seeds","Chilli","Corn Seeds"]
	var x = 0
	for child in row.get_children():
		var icon = child.get_child(0)
		var label = child.get_child(1)
		var amount = child.get_child(2)
		label.text = labels[x]
		x+=1
		amount.text = "0"
		child.pressed.connect(func(): 
			itemView.changeItem(label.text, icon.texture, amount.text, 1))
	pass # Replace with function body.

func toggleInventory():
	visible = not visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func buildInventory():
	var values = [main.corn_ammo,main.corn_seeds,main.chili_ammo,main.chili_seeds]
	var x = 0
	for child in row.get_children():
		var label = child.get_child(2)
		label.text = str(values[x])
		x += 1
