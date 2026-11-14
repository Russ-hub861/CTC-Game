extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD.hide()
	$TutorialPopup.start_tutorial()
	$Player.global_position = get_node("PlayerSpawn").global_position
	$Player.global_position.y += get_node("PlayerSpawn").global_position.y - get_node("Player/GroundMarker").global_position.y



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_skip_button_pressed() -> void:
	$TutorialPopup.skip_tutorial()
	$SkipButton.hide()
	$ContinueButton.show()


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://test_main.tscn")


func _on_tutorial_popup_tutorial_completed() -> void:
	$ContinueButton.show()
