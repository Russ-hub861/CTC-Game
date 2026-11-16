extends Button

@export var action_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(on_button_clicked)
	UiManager.update_button.connect(recieve_new_text_data)
	
	var get_events = InputMap.action_get_events(action_name)
	if(get_events == null or get_events.size() == 0):
		return
	text = get_events[0].as_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_button_clicked() -> void:
	UiManager.update_control(action_name)
	
func recieve_new_text_data(act_name: String, new_button_name: String):
	if(act_name != action_name):
		return
	
	text = new_button_name
