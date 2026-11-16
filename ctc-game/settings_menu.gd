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
	
	$VBoxContainer/Sliders/MasterSlider.value = db_to_linear(
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Master")
		)
	) * 100
	
	$VBoxContainer/MusicContainer/MusicSlider.value = db_to_linear(
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Music")
		)
	) * 100
	
	$VBoxContainer/SFXContainer/SFXSlider.value = db_to_linear(
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("SFX")
		)
	) * 100

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
	
func _on_controls_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/control_remap.tscn")
	


func _on_master_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")

	if value == 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value / 100.0)
		)



func _on_music_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")

	if value == 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value / 100.0)
		)



func _on_sfx_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")

	if value == 0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value / 100.0)
		)
