
extends Node2D
class_name FarmPlot

# Signals sent to DayController.
signal harvested(crop_type: String, bonus: int)
signal weed_cleared

# Root folder of all crop images.
const CROP_ROOT = "res://Art/cozy_harvest_crops_pack_v1.1/individual_crops_16.16"

# Information about the nine available crops.
const CROP_INFO = {
	"tomato": {"folder": "01_tomato", "prefix": "tomato"},
	"cucumber": {"folder": "02_cucumber", "prefix": "cucumber"},
	"corn": {"folder": "04_corn", "prefix": "corn"},
	"pumpkin": {"folder": "05_pumpkin", "prefix": "pumpkin"},
	"onion": {"folder": "08_onion", "prefix": "onion"},
	"chilli": {"folder": "10_red_chili", "prefix": "red_chili"},
	"radish": {"folder": "13_purple_radish", "prefix": "purple_radish"},
	"potato": {"folder": "14_potato", "prefix": "potato"},
	"carrot": {"folder": "17_carrot", "prefix": "carrot"}
}

# Time needed for a crop to grow.
@export_range(1.0, 300.0, 1.0)
var grow_seconds: float = 13.0

# Store the five textures of each crop.
var crop_textures: Dictionary = {}

# Current crop information.
var crop_type: String = ""
var growth_time: float = 0.0
var growth_multiplier: float = 1.0
var is_grown: bool = false
var has_weed: bool = false
var highlighted: bool = false
var harvest_bonus: int = 0
var current_stage: int = -1

# Get the child nodes.
@onready var soil_sprite: Sprite2D = $Soil
@onready var crop_sprite: Sprite2D = $Crop

# Called when the scene starts.
func _ready() -> void:
	soil_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	crop_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	crop_sprite.texture = null
	_load_crop_textures()
	print("FarmPlot loaded: ", crop_textures.keys())

# Load all five growth stages.
func _load_crop_textures() -> void:
	for crop_name in CROP_INFO:
		var info: Dictionary = CROP_INFO[crop_name]
		var stage_textures: Array[Texture2D] = []
		for stage in range(1, 6):
			var texture_path = "%s/%s/%s_growth_stage_%d.png" % [
				CROP_ROOT,
				info["folder"],
				info["prefix"],
				stage
			]
			var texture = load(texture_path) as Texture2D
			if texture == null:
				push_error("Cannot load crop: " + texture_path)
				stage_textures.clear()
				break
			stage_textures.append(texture)
		if stage_textures.size() == 5:
			crop_textures[crop_name] = stage_textures

# Update the crop every frame.
func _process(delta: float) -> void:
	if crop_type.is_empty() or is_grown:
		return
	growth_time += delta * growth_multiplier
	var progress = clampf(growth_time / maxf(grow_seconds, 0.1), 0.0, 1.0)
	var stage_index = mini(int(progress * 5.0), 4)
	if stage_index != current_stage:
		current_stage = stage_index
		_show_crop_stage(stage_index)
	if growth_time >= maxf(grow_seconds, 0.1):
		is_grown = true
		current_stage = 4
		_show_crop_stage(4)
	queue_redraw()

# Display a particular growth stage.
func _show_crop_stage(stage_index: int) -> void:
	if not crop_textures.has(crop_type):
		return
	var stages: Array = crop_textures[crop_type]
	if stage_index < 0 or stage_index >= stages.size():
		return
	crop_sprite.texture = stages[stage_index] as Texture2D
	# Align the bottom of the crop with the soil.
	var crop_height = crop_sprite.texture.get_height()
	crop_sprite.position.y = -float(crop_height) * crop_sprite.scale.y / 2.0

# Check whether this plot can be planted.
func can_plant() -> bool:
	return crop_type.is_empty() and not has_weed

# Plant a new crop.
func plant(seed_name: String, perfect: bool = false) -> bool:
	if not can_plant():
		return false
	if not crop_textures.has(seed_name):
		return false
	crop_type = seed_name
	growth_time = 0.0
	is_grown = false
	current_stage = 0
	# Perfect planting gives a growth bonus.
	growth_multiplier = 1.35 if perfect else 1.0
	harvest_bonus = 5 if perfect else 0
	_show_crop_stage(0)
	queue_redraw()
	return true

# Interact with this plot.
func interact() -> String:
	# Remove weeds first.
	if has_weed:
		has_weed = false
		weed_cleared.emit()
		queue_redraw()
		return "Weeds cleared!"
	# Check whether the plot is empty.
	if crop_type.is_empty():
		return "Empty soil."
	# Check whether the crop is mature.
	if not is_grown:
		return "Your crop is still growing."
	# Save the harvest information.
	var result = crop_type
	var bonus = harvest_bonus
	clear_crop()
	harvested.emit(result, bonus)
	return "Harvested " + result.capitalize() + "!"

# Clear the crop after harvesting.
func clear_crop() -> void:
	crop_type = ""
	growth_time = 0.0
	is_grown = false
	growth_multiplier = 1.0
	harvest_bonus = 0
	current_stage = -1
	crop_sprite.texture = null
	queue_redraw()

# Create weeds on an empty plot.
func spawn_weed() -> bool:
	if not can_plant():
		return false
	has_weed = true
	queue_redraw()
	return true

# Highlight the selected plot.
func set_highlighted(value: bool) -> void:
	if highlighted == value:
		return
	highlighted = value
	queue_redraw()

# Save the current crop information.
func get_save_data() -> Dictionary:
	return {
		"crop_type": crop_type,
		"growth_time": growth_time,
		"is_grown": is_grown,
		"has_weed": has_weed,
		"growth_multiplier": growth_multiplier,
		"harvest_bonus": harvest_bonus
	}

# Restore the crop after changing scenes.
func load_save_data(data: Dictionary) -> void:
	crop_type = str(data.get("crop_type", ""))
	growth_time = float(data.get("growth_time", 0.0))
	is_grown = bool(data.get("is_grown", false))
	has_weed = bool(data.get("has_weed", false))
	growth_multiplier = float(data.get("growth_multiplier", 1.0))
	harvest_bonus = int(data.get("harvest_bonus", 0))
	if not crop_type.is_empty():
		if not crop_textures.has(crop_type):
			push_warning("Unknown crop type: " + crop_type)
			clear_crop()
			return
		if is_grown:
			current_stage = 4
		else:
			var progress = clampf(growth_time / maxf(grow_seconds, 0.1), 0.0, 1.0)
			current_stage = mini(int(progress * 5.0), 4)
		_show_crop_stage(current_stage)
	else:
		crop_sprite.texture = null
		current_stage = -1
	queue_redraw()

# Draw the selection outline, weeds and growth bar.
func _draw() -> void:
	if highlighted:
		draw_rect(Rect2(-34, -34, 68, 68), Color("#f2df93"), false, 3.0)
	if has_weed:
		for x in [-16, 0, 16]:
			draw_line(Vector2(x, 20), Vector2(x - 5, 2), Color("#376b48"), 2.0)
			draw_line(Vector2(x, 16), Vector2(x + 5, 5), Color("#77ae55"), 2.0)
	if not crop_type.is_empty() and not is_grown:
		var progress = clampf(growth_time / maxf(grow_seconds, 0.1), 0.0, 1.0)
		draw_rect(Rect2(-22, 27, 44, 5), Color("#49372c"))
		draw_rect(Rect2(-21, 28, 42.0 * progress, 3), Color("#c4e68c"))
	if is_grown and crop_sprite.texture != null:
		var crop_top = crop_sprite.position.y - float(crop_sprite.texture.get_height()) * crop_sprite.scale.y / 2.0
		draw_circle(Vector2(0, crop_top - 6), 3.0, Color("#fff0b0"))
