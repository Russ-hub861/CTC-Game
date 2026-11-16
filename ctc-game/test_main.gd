extends Node2D
var current_level
@onready var player = $Player
@onready var hud = $HUD
var is_level2 = false
#Sets the amount, type and spawn delay of enemies for each level as well as
# the number of waves
var level_1_waves = [
	{
		"enemies": 2,
		"spawn_delay": 2.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":70},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":30}
		]
	},
	{
		"enemies": 3,
		"spawn_delay": 3.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":60},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":40}
		]
	},
	{
		"enemies": 2,
		"spawn_delay": 1.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":50},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":50}
		]
	}
]
var level_2_waves = [
	{
		"enemies": 3,
		"spawn_delay": 2.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":70},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":30}
		]
	},
	{
		"enemies": 2,
		"spawn_delay": 1.5,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":60},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":40}
		]
	},
	{
		"enemies": 2,
		"spawn_delay": 1.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":50},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":50}
		]
	}
]
#loads the specific level that is intended and spawns player
func load_level(level_scene):
	if current_level:
		current_level.queue_free()
	current_level = level_scene.instantiate()
	$LevelContainer.add_child(current_level)
	$Player.global_position = current_level.get_node("PlayerSpawn").global_position
	$Player.global_position.y += current_level.get_node("PlayerSpawn").global_position.y - get_node("Player/GroundMarker").global_position.y
	
	if not $Player.died.is_connected(_on_player_died):
		$Player.died.connect(_on_player_died)

	if not $Player.turn_finished.is_connected(_on_player_turn_finished):
		$Player.turn_finished.connect(_on_player_turn_finished)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Loads the first level and connects the player and hud signals
	load_level(preload("res://level_2.tscn"))
	$WaveManager.start_level(current_level,level_1_waves)
	player.health_changed.connect(hud.update_health)
	player.cooldown_changed.connect(hud.update_cooldowns)
	hud.update_health(player.health)
	player.exp_changed.connect(hud.update_exp)
	hud.update_exp(player.current_exp, player.exp_to_next_level, player.level)

#unpauses game when resume button is pressed
func _on_resume_button_pressed():
	get_tree().paused = false
	hide()
#changes scene to Main menu when quit button is pressed
func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _process(_delta):
	#Checks to see if pause button is pressed, if so 
	#make the pause menu visible
	if Input.is_action_pressed("pause"):
		$PauseMenu.visible = !$PauseMenu.visible
		get_tree().paused = $PauseMenu.visible
	
		
#Shows death screen if player dies
func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://death_screen.tscn")
	$levelMusic.stop()
	

func _on_player_turn_finished() -> void:
	player.can_control = false
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if player.is_dead:
			return
		if not is_instance_valid(enemy):
			continue
		await enemy.take_turn()
	player.is_blocking = false
	player._set_outline(player.animated_sprite, false)
	#print("Player has stopped blocking")
	player.can_control = true
	

#Shows next button once the level has been completed
func _on_wave_manager_level_done() -> void:
	$NextButton.show()

#changes level once next button is pressed
func _on_next_button_pressed() -> void:
	if is_level2:
		get_tree().change_scene_to_file("res://cut_scene.tscn")
	else:
		load_level(preload("res://level_1_fr.tscn"))
		$NextButton.hide()
		$NextButton.text = "Escape the dungeon"
		$WaveManager.start_level(current_level,level_2_waves)
		
		# uncomment to regan player's HP
		# player.health = player.max_health
		
		player.health_changed.emit(player.health)
		
		is_level2 = true
