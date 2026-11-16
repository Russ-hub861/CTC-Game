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
	#Sets this the maser slider to mathch the master volume bus
	$VBoxContainer/Sliders/MasterSlider.value = db_to_linear(
		#Gets the current bus volume
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Master")
		)
	) * 100 #Sets Value as a percentage
	
	#Exact same thing as master slider just for the music slider
	$VBoxContainer/MusicContainer/MusicSlider.value = db_to_linear(
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Music")
		)
	) * 100
	#Exact same thing as master slider just for the SFX slider
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

#Unpauses the game and hides the settings menu when the resume button is pressed
func _on_resume_button_pressed():
	get_tree().paused = false
	hide()

#Chnages scene to main menu when quit button is pressed
func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	
#Opens up the controls menu when the controls button is pressed
func _on_controls_button_pressed():
	$ControlsPage.show()
	$VBoxContainer.hide()
	

#Finds and changes master audio when the master slider is moved
func _on_master_slider_value_changed(value: float) -> void:
	#Finds the Master audio bus
	var bus_index = AudioServer.get_bus_index("Master")
#Checks whether the slider is at zero and mutes it, if not it unmutes the bus
#And changes audio
	if value == 0:
		AudioServer.set_bus_mute(bus_index, true)
# Converts the slider percentage into decibels and applies the new volume
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value / 100.0)
		)


#Does the same thing for the music slider as the master slider
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


#Does the same thing as the previous two blocks of code jsut for the sfx slider
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
