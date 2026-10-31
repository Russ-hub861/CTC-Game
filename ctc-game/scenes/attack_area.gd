extends Area2D

@onready var hitbox = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false
	hitbox.disabled = true 
	#body_entered.connect(_on_body_entered)
	
func start_attack():
	hitbox.disabled = false 
	monitoring = true 
	
func end_attack():
	monitoring = false 
	hitbox.disabled = true 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.take_damage(2)
