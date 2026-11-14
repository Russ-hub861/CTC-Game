extends CanvasLayer


var max_health = 20
var current_health = 20

@onready var exp_bar: ProgressBar = $ExpBar
@onready var level_label: Label = $LevelLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#update_health(new_health)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_health(new_health: int):
	#current_health = new_health
	var hearts = $VBoxContainer.get_children()

	for row in hearts:
		for heart in row.get_children():
			var index = hearts.find(row) * 10 + row.get_children().find(heart)
			if index < new_health:
				heart.show()
			else:
				heart.hide()


func update_exp(current_exp: int, max_exp: int, level: int) -> void:
	exp_bar.max_value = max_exp
	exp_bar.value = current_exp
	level_label.text = "Lv." + str(level)

		
