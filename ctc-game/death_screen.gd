extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Plays player death sound
	$DeathSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Goes to Title screen when the back button gets pressed
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
