extends Node2D
var current_level
@onready var player = $Player


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
		"spawn_delay": 1.5,
		"enemy_pool": [
			{"scene":preload("res://scenes/goblin_thief.tscn"), "weight":60},
			{"scene":preload("res://scenes/goblin_tank.tscn"), "weight":40}
		]
	},
	{
		"enemies": 4,
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
	$Player.died.connect(_on_player_died)
	$Player.turn_finished.connect(_on_player_turn_finished)	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(preload("res://level_2.tscn"))
	$WaveManager.start_level(current_level,level_1_waves)
	
<<<<<<< HEAD
=======
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
	
>>>>>>> ad19a61810c47abeded80258126c16acf23cadd6
