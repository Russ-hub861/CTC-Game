extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2d
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Enemy scene started!")
	animated_sprite.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
