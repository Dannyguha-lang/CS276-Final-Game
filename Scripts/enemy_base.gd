class_name EnemyBase
extends CharacterBody2D
signal died(enemy: EnemyBase)

@export var max_health := 30.0
@export var speed := 60.0
@export var damage := 5.0
@export var element := "none"
@export var attack_cooldown := 0.5
@export var attack_range := 5
@export var repath_cooldown := 0.5
var health: float
var target: Node2D

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var attack_timer: Timer = $AttackTimer
@onready var repath_timer: Timer = $RepathTimer

var nav_ready := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")     
	health = max_health
	target = get_tree().get_first_node_in_group("player")
	setBase()
	
	
func setBase():
	attack_timer.stop()
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_cooldown
	attack_timer.start()
	repath_timer.one_shot = true
	repath_timer.wait_time = repath_cooldown
	
	nav.path_desired_distance = 8.0
	nav.target_desired_distance = attack_range
	nav_ready = true
func attack():
	if target and attack_timer.is_stopped():
		target.takeDamage(damage,element)
		attack_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not nav_ready or not is_instance_valid(target):
		pass
	behave()
	
func move_toward_target() -> void:
	if repath_timer.is_stopped():
		nav.target_position = target.global_position
		repath_timer.start()
 
	if nav.is_navigation_finished():
		velocity = Vector2.ZERO
		return
 
	var next_pos := nav.get_next_path_position()
	velocity = global_position.direction_to(next_pos) * speed
	move_and_slide()

func behave() -> void:

	if not target:
		pass
	elif global_position.distance_to(target.global_position) <= attack_range:
		velocity = Vector2.ZERO
		attack()
	else:
		move_toward_target()
		
func takeDamage(amount: float, attack_element := "none") -> void:
	health -= amount * Elements.attackMultiplier(attack_element, element) 
	if health <= 0.0:
		die()

func die() -> void:
	died.emit(self)
	queue_free()
