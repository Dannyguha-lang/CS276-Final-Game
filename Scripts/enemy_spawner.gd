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
