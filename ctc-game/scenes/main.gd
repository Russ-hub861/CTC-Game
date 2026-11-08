extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$TutorialPopup.start_tutorial()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://settings_menu.tscn")
