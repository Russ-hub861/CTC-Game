extends Control

signal update_button(newText: String, actionName: String)
var modify_control: bool = false
var modify_action: String
var control_data = {}

func _input(event: InputEvent) -> void:
	if(!modify_control or event is InputEventMouseMotion or !InputMap.has_action(modify_action)):
		return
		
	InputMap.action_erase_events(modify_action)
	InputMap.action_add_event(modify_action, event)

	modify_control = false
	update_button.emit(modify_action, event.as_text())
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_control(new_action: String):
	modify_action = new_action
	modify_control = true
