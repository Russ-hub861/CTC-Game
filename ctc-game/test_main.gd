extends Node2D
var current_level

var enemy_scene = preload("res://scenes/goblin_thief.tscn")

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	$LevelContainer.add_child(enemy)
	enemy.global_position = current_level.get_node("EnemySpawn1").global_position


func load_level(level_scene):
	if current_level:
		current_level.queue_free()
	current_level = level_scene.instantiate()
	$LevelContainer.add_child(current_level)
	$Player.global_position = current_level.get_node("PlayerSpawn").global_position
	spawn_enemy()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(preload("res://level_2.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
