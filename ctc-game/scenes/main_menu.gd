extends Control

@onready var dog = $Dog
@onready var settings_menu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	dog.play("Idle")
	if is_instance_valid(settings_menu):
		settings_menu.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_settings()

func toggle_settings() -> void:
	if not is_instance_valid(settings_menu):
		return
	
	if settings_menu.visible:
		settings_menu.hide()
	else:
		settings_menu.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://tutorial_level.tscn")
