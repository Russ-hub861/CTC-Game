extends Node2D
@onready var player = $Player
@onready var hud = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_changed.connect(hud.update_hearts)
	hud.update_hearts(player.health)
	$TutorialPopup.start_tutorial()
	$Player.died.connect(_on_player_died)
	$Player.turn_finished.connect(_on_player_turn_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://settings_menu.tscn")
		
func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://death_screen.tscn")
	
func _on_player_turn_finished() -> void:
	player.can_control = false
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if player.is_dead:
			return
		if not is_instance_valid(enemy):
			continue
		await enemy.take_turn()
	player.can_control = true
	
