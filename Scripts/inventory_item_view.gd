extends CenterContainer

@onready var item_image = $InventoryItemView/ItemImage
@onready var item_name = $InventoryItemView/ItemName
@onready var item_amount = $InventoryItemView/ItemAmount
@onready var item_value = $InventoryItemView/ItemValue
@onready var item_sell = $InventoryItemView/SellItem
var current_item = "None"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeItem(item,image,iamount,value):
	if visible and (item == current_item or item == "None"):
		hide()
		await get_tree().process_frame
		get_parent().get_parent().get_parent().reset_size() 
		current_item = "None"
		return
	current_item = item
	item_image.texture = image
	item_name.text = "Name: "+ item
	item_amount.text = "Amount: " + iamount
	item_value.text = "Value:" + str(value)
	show()
