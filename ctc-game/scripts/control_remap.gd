extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("toggle_skill_menu"):
		toggle_menu()

func toggle_menu():
	visible = !visible
	get_tree().paused = visible

func _on_save_changes_pressed() -> void:
	hide()
	get_parent().get_node("VBoxContainer").show()
