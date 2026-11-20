extends Control

signal update_button(newText: String, actionName: String)
var modify_control: bool = false
var modify_action: String
var control_data = {}

func _input(event: InputEvent) -> void:
	if not modify_control or not InputMap.has_action(modify_action):
		return
	if event is InputEventKey and event.pressed and not event.echo:
		var key_event := InputEventKey.new()
		key_event.physical_keycode = event.physical_keycode
		InputMap.action_erase_events(modify_action)
		InputMap.action_add_event(modify_action, key_event)
		
		modify_control = false
		update_button.emit(modify_action, key_event.as_text())
		get_viewport().set_input_as_handled()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_control(new_action: String):
	modify_action = new_action
	modify_control = true
