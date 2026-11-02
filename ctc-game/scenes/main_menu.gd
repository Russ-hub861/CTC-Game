extends Control

@onready var dog = $Dog

# Called when the node enters the scene tree for the first time.
func _ready():
	dog.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
