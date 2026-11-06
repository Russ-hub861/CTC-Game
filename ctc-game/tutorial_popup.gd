extends Control

var messages = [
	"Use the arrow keys to move!",
	"Use the space bar to attack!",
	"Your health is located in the top left corner", 
	"once its depleated your run will be over.",
	"Press 'esc' to pause, quit, or to look at the controls"
]
var current_message = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func display_message():
	#print("Showing message: ", messages[current_message])
	if current_message >= messages.size():
		visible = false
		return
	$Label.text = messages[current_message]
	visible = true
	$Timer.start()
	
func start_tutorial():
	current_message = 0
	display_message()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout():
	#print("Display timer finished")
	visible = false
	$Delaytimer.start()


func _on_delaytimer_timeout() -> void:
	current_message += 1
	display_message()
