extends Node2D
var current_level
@onready var player = $Player
@onready var hud = $HUD

var level_1_waves = [
	{
		"enemies": 1,
		"spawn_delay": 2.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":70},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":30}
		]
	},
	{
		"enemies": 1,
		"spawn_delay": 1.5,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":60},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":40}
		]
	},
	{
		"enemies": 1,
		"spawn_delay": 1.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":50},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":50}
		]
	}
]


func load_level(level_scene):
	if current_level:
		current_level.queue_free()
	current_level = level_scene.instantiate()
	$LevelContainer.add_child(current_level)
	$Player.global_position = current_level.get_node("PlayerSpawn").global_position
	$Player.global_position.y += current_level.get_node("PlayerSpawn").global_position.y - get_node("Player/GroundMarker").global_position.y
	$Player.died.connect(_on_player_died)
	$Player.turn_finished.connect(_on_player_turn_finished)	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(preload("res://level_2.tscn"))
	$WaveManager.start_level(current_level,level_1_waves)
	player.health_changed.connect(hud.update_hearts)
	hud.update_hearts(player.health)
	player.exp_changed.connect(hud.update_exp)
	hud.update_exp(player.current_exp, player.exp_to_next_level, player.level)

func _on_resume_button_pressed():
	get_tree().paused = false
	hide()

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _process(_delta):
	if Input.is_action_pressed("pause"):
		$PauseMenu.visible = !$PauseMenu.visible
		get_tree().paused = $PauseMenu.visible
	
		



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
	


func _on_wave_manager_level_done() -> void:
	$NextButton.show()


func _on_next_button_pressed() -> void:
	load_level(preload("res://level_1_fr.tscn"))
	$NextButton.hide()
	$WaveManager.start_level(current_level,level_1_waves)
	player.health_changed.connect(hud.update_hearts)
	hud.update_hearts(player.health)
