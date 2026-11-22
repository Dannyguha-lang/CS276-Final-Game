extends Node2D
@export var max_enemies = 100
@export var spawn_time = 0.1
@export var enemy_base:PackedScene
var enemy_unlocks = {"ladybird":0,"rat":0,"bee":3,"fish":4,"snail":1,"bat":2,"spider":0}

@onready var spawn_timer: Timer = $SpawnerTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	if enemy_base == null:
		push_error("EnemySpawner: enemy_base is not assigned in the Inspector!")
		return
		
	var test_bug = enemy_base.instantiate()
	
	# Verify script path exists before loading
	var script_path := "res://scripts/ladybug.gd" # <-- Update if in a different folder
	if ResourceLoader.exists(script_path):
		test_bug.set_script(load(script_path))
	else:
		push_error("Could not find script at: " + script_path)
		
	add_child(test_bug)
	
	# Verify image path exists and apply to Sprite2D
	var img_path := "res://Art/enemies/ladybird.png" # <-- Check if named ladybird.png or ladybug.png
	var sprite := test_bug.get_node_or_null("Sprite2D")
	if sprite and ResourceLoader.exists(img_path):
		sprite.texture = load(img_path)
	else:
		push_error("Sprite2D missing or image not found at: " + img_path)
		
	test_bug.global_position = Vector2(512, 512)
	print("Spawned test ladybug at: ", test_bug.global_position)
	
func startTimer():
	spawn_timer.start()

func stopTimer():
	spawn_timer.stop()
func _on_spawn_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("enemies").size() >= max_enemies:
		return
 
	var enemy = enemy_base.instantiate()
	var enemy_type = getRandomEnemy()
	
	var path = "res://Scripts/" + str(enemy_type) + ".gd"
	
	if not ResourceLoader.exists(path):
		push_error("No script for enemy type: " + enemy_type)
	else:
		enemy.set_script(load(path))
	enemy.get_child(0).texture = load("res://Art/enemies/" + enemy_type + ".png")
	enemy.global_position = randomEdge(enemy_type)
	add_child(enemy)

func getRandomEnemy():
	var pool = []
	for type in enemy_unlocks:
		if enemy_unlocks[type] <= Inventory.current_cycle:
			pool.append(type)
	var ran = randi_range(0,len(pool) - 1)
	return pool[ran]

func updateMaxEnemies(num):
	max_enemies = num
func randomEdge(type):
	if type == "fish":
		var radius = 150
		var centre = Vector2(200,350)
		return centre + Vector2(randi_range(0,radius),randi_range(0,radius))
	var ran = randi_range(0,3)
	match ran:
		0:
			return Vector2(0,randi_range(0,864))
		1:
			return Vector2(1536,randi_range(0,864))
		2:
			return Vector2(randi_range(0,1536),0)
		3:
			return Vector2(randi_range(0,1536),864)
	return Vector2(0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
