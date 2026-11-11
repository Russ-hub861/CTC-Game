extends Control

@onready var fullscreen_toggle: Button = $VBoxContainer/FullscreenToggle
@onready var resume_button: Button = $VBoxContainer/ResumeButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	if get_tree().current_scene and get_tree().current_scene.name == "MainMenu":
		resume_button.hide()
		# quit_button.hide()
	
	var current_mode = DisplayServer.window_get_mode()
	fullscreen_toggle.button_pressed = (
		current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or 
		current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	)
	
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and is_visible_in_tree() and is_instance_valid(fullscreen_toggle):
		var current_mode = DisplayServer.window_get_mode()
		fullscreen_toggle.button_pressed = (
			current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or 
			current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	fullscreen_toggle.text = "Fullscreen: ON" if toggled_on else "Fullscreen: OFF"
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resume_button_pressed():
	get_tree().paused = false
	hide()

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	
