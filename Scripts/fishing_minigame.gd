extends PanelContainer

enum State { IDLE, WATCH, HIDDEN, GUESS, REVEAL }
@export var cycles_visible := 2.0
@export var hidden_time := 1.7


var state := State.IDLE
var t := 0.0
var target := Vector2.ZERO
var centre := Vector2.ZERO
const weapon_chance = 0.10
@export var period := 2.5
@export var radius := Vector2(140, 90)
@export var freq := Vector2(1, 2)
@onready var shadow: Sprite2D = $Background/Water/Shadow
@onready var bobber: Sprite2D = $Background/Water/Bobber
@onready var water: TextureRect = $Background/Water
@onready var result_container:PanelContainer = $ResultContainer
@onready var result:Label = $ResultContainer/Result

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.
func _input(event) -> void:
	if state == State.GUESS and event.is_action_pressed("cast"):
		guess()
func start() -> void:
	result.hide()
	result_container.hide()
	show()
	await get_tree().process_frame
	centre = water.size / 2.0
	t = 0.0
	cycles_visible = randf_range(1.5,2.5)
	target = Vector2.ZERO
	state = State.WATCH
	shadow.show()
	bobber.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		State.WATCH:
			t += delta
			shadow.show()
			shadow.position = centre + pattern(t)
			if t >= period * cycles_visible:
				state = State.HIDDEN
		State.HIDDEN:
			t += delta
			shadow.hide()
			if t >= period * cycles_visible + hidden_time:
				state = State.GUESS
				bobber.show()
		State.GUESS:
			t+=1
			bobber.position = get_local_mouse_position()


func calculateRarity(dist):
	var chance = 0.03
	if dist <= 3:
		chance += 0.03
	elif dist <= 6:
		chance += 0.02
	elif dist <= 9:
		chance += 0.01
	elif dist <= 12:
		chance -= 0.00
	elif dist <= 15:
		chance -= 0.01
	elif dist <= 18:
		chance -= 0.02
	else:
		chance -= 0.03
	var rand = randf()
	if rand <= chance:
		return "legendary"
	if rand <= chance * 3:
		return "epic"
	if rand <= chance * 6:
		return "rare"
	if rand <= chance * 10:
		return "uncommon"
	return "common"
	

func calculateCatch():
	var rand = randf()
	if rand < weapon_chance:
		return "weapon"
	return "fish"
	
func guess() -> void:
	state = State.REVEAL
	target = centre + pattern(t)
	var dist := bobber.position.distance_to(target)
	shadow.position = target
	shadow.show()
	
	print(dist)
	var catch = calculateCatch()
	var rarity = calculateRarity(dist)
	await get_tree().create_timer(1).timeout
	shadow.hide()
	result.text = "catch: %s \n rarity: %s" % [catch,rarity]
	result.show()
	result_container.show()
	await get_tree().create_timer(2).timeout
	start()
	
func end() -> void:
	state = State.IDLE
	hide()		


func pattern(time:float):
	var a := time * TAU / period
	return Vector2(sin(a * freq.x) * radius.x, sin(a * freq.y + 1.0) * radius.y)
