extends Node2D
@onready var player = $Player
@onready var hud = $HUD
var current_level


var level_2_waves = [
	{
		"enemies": 2,
		"spawn_delay": 2.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":70},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":30}
		]
	},
	{
		"enemies": 4,
		"spawn_delay": 3.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":60},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":40}
		]
	},
	{
		"enemies": 3,
		"spawn_delay": 1.0,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":50},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":50}
		]
	}
]
# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_changed.connect(hud.update_hearts)
	hud.update_hearts(player.health)
	$WaveManager.start_level(current_level,level_2_waves)
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
	player.is_blcoking = false
	print("Player is done blocking")
	player.can_control = true
	
