extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 300.0
var damage: float = 5.0
var element: String = "none"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(2.0).timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		return
	if body.is_in_group("player") and body.has_method("takeDamage"):
		body.takeDamage(damage, element)
	queue_free()
