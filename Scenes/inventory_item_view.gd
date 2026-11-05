extends VBoxContainer

@onready var item_image = $ItemImage
@onready var item_name = $ItemName
@onready var item_value = $ItemValue
@onready var item_sell = $ItemSell
var current_item = "None"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeItem(item,image,iname,value):
	if visible and (item == current_item or item == "None"):
		hide()
		get_parent().get_parent().reset_size() 
		current_item = "None"
		return
	current_item = item
	item_image.texture = image
	item_name.text = iname
	item_value.text = str(value)
	show()
