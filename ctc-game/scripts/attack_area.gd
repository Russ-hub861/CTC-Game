extends Area2D

@onready var hitbox = $CollisionShape2D

var _already_hit: Array[Node] = []

func _ready() -> void:
	monitoring = false
	hitbox.disabled = true
	body_entered.connect(_on_body_entered)

func start_attack() -> void:
	_already_hit.clear()
	hitbox.disabled = false
	monitoring = true
	# Bodies already overlapping do not emit body_entered, so check them
	# after the physics server refreshes the area.
	await get_tree().physics_frame
	if not monitoring:
		return
	for body in get_overlapping_bodies():
		_try_damage(body)

func end_attack() -> void:
	monitoring = false
	hitbox.disabled = true
	_already_hit.clear()

func _on_body_entered(body: Node2D) -> void:
	_try_damage(body)

func _try_damage(body: Node) -> void:
	if body in _already_hit:
		return
	if not body.is_in_group("Enemies"):
		return
	if not body.has_method("take_damage"):
		return
	_already_hit.append(body)
	body.take_damage(2)
