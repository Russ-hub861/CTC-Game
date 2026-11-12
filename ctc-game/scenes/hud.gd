extends CanvasLayer



@onready var half_heart = preload("res://Art/hearts/HalfHeart.png")

@onready var hearts = [
	$HeartContainer/Heart1,
	$HeartContainer/Heart2,
	$HeartContainer/Heart3
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_hearts(new_health):
	if new_health == 4:
		hearts[2].hide()
	elif new_health == 2:
		hearts[1].hide()
	elif new_health == 0:
		hearts[0].hide()
		
