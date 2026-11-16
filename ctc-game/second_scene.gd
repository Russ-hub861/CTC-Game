extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Plays the animation
	$AnimationPlayer.play("lostDog")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Checks to see if the animation has stopped and once it does it changes to main menu scene
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "lostDog":
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
