extends Node2D

var current_wave = 0
var enemies_alive = 0
var all_enemies_spawned = false
var wave_transitioning = false
var current_level: Node2D
var waves: Array = []
var enemy_scene = preload("res://scenes/goblin_thief.tscn")

func _on_enemy_died():
	enemies_alive -=1
	check_wave_completion()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	current_level.add_child(enemy)
	enemy.global_position = current_level.get_node("EnemySpawn1").global_position
	enemies_alive += 1
	enemy.died.connect(_on_enemy_died)

func start_level(level: Node2D, level_waves: Array):
	current_level = level
	waves = level_waves
	current_wave = 0
	enemies_alive = 0
	start_wave()

func start_wave():
	if current_wave >= waves.size():
		#level_completed()
		return

	all_enemies_spawned = false
	wave_transitioning = false

	var wave = waves[current_wave]
	var enemy_count = wave["enemies"]
	var spawn_delay = wave["spawn_delay"]

	print("Starting wave ", current_wave + 1)

	for i in range(enemy_count):
		spawn_enemy()
		if i < enemy_count -1:
			await get_tree().create_timer(spawn_delay).timeout

	all_enemies_spawned = true
	check_wave_completion()
	

func check_wave_completion():
	if all_enemies_spawned and enemies_alive == 0 and not wave_transitioning:
		wave_completed()

func wave_completed():
	wave_transitioning = true
	await get_tree().create_timer(2.0).timeout
	current_wave += 1
	start_wave()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
