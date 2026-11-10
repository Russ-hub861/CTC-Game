extends Node2D
var current_level

var level_1_waves = [
	{
		"enemies": 2,
		"spawn_delay": 2.0
	},
	{
		"enemies": 3,
		"spawn_delay": 1.5
	},
	{
		"enemies": 4,
		"spawn_delay": 1.0
	}
]


func load_level(level_scene):
	if current_level:
		current_level.queue_free()
	current_level = level_scene.instantiate()
	$LevelContainer.add_child(current_level)
	$Player.global_position = current_level.get_node("PlayerSpawn").global_position
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(preload("res://level_2.tscn"))
	$WaveManager.start_level(current_level,level_1_waves)
