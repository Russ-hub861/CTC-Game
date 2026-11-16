extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Hides HUD temproarily
	$HUD.hide()
	#Starts tutorial
	$TutorialPopup.start_tutorial()
	#Spawns it player at spawn marker
	$Player.global_position = get_node("PlayerSpawn").global_position
	$Player.global_position.y += get_node("PlayerSpawn").global_position.y - get_node("Player/GroundMarker").global_position.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Checks toe see if the pause menu button has been pressed and if so shows the settings screen
	#and plays music
	if Input.is_action_pressed("pause"):
		_toggle_settings()
	if !$PauseMenu.visible == true:
		$TutorialMusic.stream_paused = false
	

#Skips all of the tutorial when the skip button is pressed
func _on_skip_button_pressed() -> void:
	$TutorialPopup.skip_tutorial()
	$SkipButton.hide()
	$ContinueButton.show()

#Takes player to the first level when the continue button is pressed
func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/test_main.tscn")

#shows continue button once tutorial has been completed
func _on_tutorial_popup_tutorial_completed() -> void:
	$ContinueButton.show()
#Shows the settings menu and pauses music
func _toggle_settings():
	$TutorialMusic.stream_paused = true
	$PauseMenu.visible = !$PauseMenu.visible
	get_tree().paused = $PauseMenu.visible
	
