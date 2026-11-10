extends Node2D

var current_wave = 0
var enemies_alive = 0
var all_enemies_spawned = false
var wave_transitioning = false
var current_level: Node2D
var waves: Array = []
var enemy_scene = preload("res://scenes/goblin_thief.tscn")
var enemy_scenetwo = preload("res://scenes/goblin_tank.tscn")

func _on_enemy_died():
	enemies_alive -=1
	check_wave_completion()

func choose_enemy(enemy_pool: Array) -> PackedScene:
	var total_weight = 0
	for enemy in enemy_pool:
		total_weight += enemy["weight"]
	var random_number = randi_range(1, total_weight)
	for enemy in enemy_pool:
		random_number -= enemy["weight"]
		if random_number <= 0:
			return enemy["scene"]
	return enemy_pool[0]["scene"]


func spawn_enemy():
	var wave = waves[current_wave]
	var enemy_pool = wave["enemy_pool"]
	var selected_scene = choose_enemy(enemy_pool)
	var enemy = selected_scene.instantiate()
	current_level.add_child(enemy)
	var spawn_point = current_level.get_node("EnemySpawn1")
	enemy.global_position = spawn_point.global_position
	enemy.died.connect(_on_enemy_died)
	enemies_alive += 1

func start_level(level: Node2D, level_waves: Array):
	$WaveMessages.hide()
	current_level = level
	waves = level_waves
	current_wave = 0
	enemies_alive = 0
	start_wave()

func start_wave():
	if current_wave >= waves.size():
		#level_completed()
		return
	$WaveMessages/wavemessage.text = "Starting wave "+str(current_wave+1)
	await get_tree().create_timer(1.0).timeout
	$WaveMessages.hide()
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
	$WaveMessages/wavemessage.text = "Wave "+str(current_wave+1)+" complete!"
	$WaveMessages.show()
	await get_tree().create_timer(2.0).timeout
	current_wave += 1
	start_wave()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
