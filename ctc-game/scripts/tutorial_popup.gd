extends Control
#List of all the messages to be displayed during tutorial
var messages = [
	"You hear an eerie voice \nfrom the statue",
	"If you ever want to see your dog agian \nYou must listen to what I say very carefully...",
	"Use the arrow keys or a and d to move",
	"use the s key to block enemy attacks \nor skip your turn",
	"Use the space bar to attack enemies",
	"Your health is located in the top left corner \n
	once its depleated you will die.",
	"Press 'esc' to pause, quit, \nand to look at the controls",
	"Every time you block, attack or \nmove a certain direction every enemy will \nget a chance to do something before you",
	"Defeat waves of enemies during \neach level in order to gain exp and level up",
	"leveling up will earn you SP which you can use to \nupgrade your attacks and\ngain your health back by pressing 'tab'",
	"When you are ready to attempt your escape \nclick the button above my head\nGood luck!"
]
var current_message = 0
var tutorial_active = false
var tutorial_finished = false
signal tutorial_completed
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
#Displays the current message

func display_message():
	#Checks whether the last message has been displayed, and if so emits a signal that 
	#the tutorial has been completed
	if current_message >= messages.size():
		visible = false
		tutorial_finished = true
		tutorial_active = false
		tutorial_completed.emit()
		return
	$Label.text = messages[current_message]
	visible = true

#Starts the tutorial
func start_tutorial():
	current_message = 0
	var tutorial_active = true
	var tutorial_finished = false
	display_message()
#Skips the tutorial
func skip_tutorial():
	visible = false
	tutorial_active = false
	tutorial_finished = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Changes tutorial message when the "next" button is pressed
func _on_button_pressed() -> void:
	current_message += 1
	display_message()
	
