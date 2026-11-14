extends Control

var messages = [
	"You hear an eerie voice \nfrom the statue",
	"If you ever want to see your dog agian \n
	You must listen to what I say very carefully...",
	"Use the arrow keys or a and d to move",
	"use the s key to block enemy attacks or skip your turn",
	"Use the space bar to attack enemies",
	"Your health is located in the top left corner \n
	once its depleated you will die.",
	"Press 'esc' to pause, quit, \nand to look at the controls",
	"Every time you complete an action such as\n blocking, attacking or moving
	each of your enemies will get a chance to do something before you",
	"Defeat waves of enemies during \neach level in order to escape",
	"When you are ready to attempt your escape \n click the button above my head",
	"Good luck!"
]
var current_message = 0
var tutorial_active = false
var tutorial_finished = false
signal tutorial_completed
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true

func display_message():
	#print("Showing message: ", messages[current_message])
	if current_message >= messages.size():
		visible = false
		tutorial_finished = true
		tutorial_active = false
		tutorial_completed.emit()
		return
	$Label.text = messages[current_message]
	visible = true
#
	
func start_tutorial():
	current_message = 0
	var tutorial_active = true
	var tutorial_finished = false
	display_message()

func skip_tutorial():
	#
	visible = false
	tutorial_active = false
	tutorial_finished = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#


#



func _on_button_pressed() -> void:
	current_message += 1
	display_message()
	
