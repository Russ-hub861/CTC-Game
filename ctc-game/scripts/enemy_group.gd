extends CharacterBody2D
class_name EnemyGroup

@export var max_health: int = 5
@export var speed: float = 100.0
@export var attack_range: float = 250.0

@export var attack_stream: AudioStreamMP3

@export var block_stream: AudioStreamMP3

@export var hit_stream: AudioStreamMP3

@export var exp_reward: int = 50

@export var block_chance: float = 0.3
var is_blocking := false

var _attack_sound: AudioStreamPlayer
var _block_sound: AudioStreamPlayer
var _hit_sound: AudioStreamPlayer

var health: int 
var is_dead: bool = false
var is_invincible: bool = false
signal died
const DAMAGE_POPUP_SCENE = preload("res://scenes/damege_popup.tscn")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

var _hit_serial := 0

const OUTLINE_SHADER := preload("res://scenes/outline.gdshader")

func _ready() -> void:
	add_to_group("Enemies")
	
	# calculate as following player's level
	var player = get_tree().get_first_node_in_group("Player")
	if player and "level" in player:
		# hp scale
		var health_scale = 1.0 + (player.level - 1) * 0.2
		max_health = round(max_health * health_scale)
		
		# exp scale
		var exp_scale = 1.0 + (player.level - 1) * 0.2
		exp_reward = round(exp_reward * exp_scale)
		
		# attacking damage scale
		var dmg_scale = 1.0 + (player.level - 1) * 0.25
		attack_area.damage_amount = round(attack_area.damage_amount * dmg_scale)
		# to check enemy's status for each player's level
		print("to check: enemy spawned, player's Lv: ", player.level, " | damage of attack", attack_area.damage_amount)
			

	# set the changed enemy's HP
	health = max_health

	# reset animations
	if sprite == null:
		return
	_setup_outline(sprite)
	_set_animation_loop(&"Hit", false)
	_set_animation_loop(&"Death", false)
	_set_animation_loop(&"Attack", false)
	_set_animation_loop(&"BasicAttack", false)
	sprite.play(&"Idle")
	
	_attack_sound = _add_sound(attack_stream)
	_block_sound = _add_sound(block_stream)
	_hit_sound = _add_sound(hit_stream)


func _add_sound(stream: AudioStream) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	return player
	
# 
func _setup_outline(sprite) -> void:
	var mat := ShaderMaterial.new()
	mat.shader = OUTLINE_SHADER
	mat.set_shader_parameter("outline_width", 0.0)
	sprite.material = mat
	
func _set_outline(sprite, enabled: bool, color: Color = Color(1, 0, 0)) -> void:
	var mat := sprite.material as ShaderMaterial
	if mat:
			mat.set_shader_parameter("outline_color", color)
			mat.set_shader_parameter("outline_width", 2.0 if enabled else 0.0)


func take_damage(amount: int) -> void:
	if is_dead or is_invincible or is_blocking:
		if is_blocking:
			_block_sound.play()
		return

	is_invincible = true
	_reset_invincibility()

	health -= amount
	_hit_sound.play()

	var popup = DAMAGE_POPUP_SCENE.instantiate()
	get_tree().current_scene.add_child(popup)
	popup.show_damage(amount, global_position + Vector2(70, -55))
	
	if sprite == null:
		if health <= 0:
			is_dead = true
			queue_free()
		return

	if health <= 0:
		is_dead = true
		_hit_serial += 1
		var player = get_tree().get_first_node_in_group("Player")
		if player and player.has_method("gain_exp"):
			player.gain_exp(exp_reward)
		sprite.play(&"Death")
		died.emit()
		await sprite.animation_finished
		queue_free()
		return

	_hit_serial += 1
	var serial := _hit_serial
	sprite.play(&"Hit")
	sprite.frame = 0
	sprite.frame_progress = 0.0
	await sprite.animation_finished

	if not is_dead and serial == _hit_serial:
		sprite.play(&"Idle")
		
func _physics_process(delta: float) -> void:
	# ... gravity, chase, and attack...
	move_and_slide() 

#func _physics_process(delta: float) -> void:
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Stay still while hurt, dead, or if this node has no sprite.
	#if is_dead or sprite == null or sprite.animation == &"Hit" or sprite.animation == &"Death":
		#velocity.x = 0
		#_end_attack()
		#move_and_slide()
		#return
#
	#var player = get_tree().get_first_node_in_group("Player")
	#if player == null:
		#velocity.x = 0
		#move_and_slide()
		#return
#
	## Face the player and walk toward them until we are close enough to attack.
	#var player_position: Vector2 = player.global_position
	#var facing_left := player_position.x < global_position.x
	#sprite.flip_h = facing_left
	## flip_h only affects sprites. Mirroring the area's scale turns the hitbox too.
	#attack_area.scale.x = -1.0 if facing_left else 1.0
#
	#if global_position.distance_to(player_position) > attack_range:
		#var direction: float = sign(player_position.x - global_position.x)
		#velocity.x = direction * speed
		#if sprite.animation != &"Idle":
			#_end_attack()
			#sprite.play(&"Idle")
	#else:
		#velocity.x = 0
		#var attack_name := &"Attack"
		#if not sprite.sprite_frames.has_animation(attack_name):
			#attack_name = &"BasicAttack"
		#if sprite.animation != attack_name:
			#attack_area.start_attack()
			#sprite.play(attack_name)
		#elif not sprite.is_playing():
			## The swing finished. Turn the box off so the next one can hit again.
			#_end_attack()
			#sprite.play(&"Idle")
#
	#move_and_slide()
func _move_once(direction: float):
	sprite.flip_h = direction < 0
	attack_area.scale.x = -1 if direction < 0 else 1
	#starts the step
	velocity.x = direction * speed
	sprite.play(&"Move")
	await get_tree().create_timer(0.4).timeout
	velocity.x = 0
	
func _play_attack() -> void:
	_attack_sound.play()
	var attack_name := &"Attack"
	if not sprite.sprite_frames.has_animation(attack_name):
		attack_name = &"BasicAttack"
	velocity.x = 0
	_set_outline(sprite, true)
	attack_area.start_attack()
	sprite.play(attack_name)
	await sprite.animation_finished
	attack_area.end_attack()
	_set_outline(sprite, false)
	sprite.play(&"Idle")
	
func _play_block() -> void: 
	_block_sound.play()
	is_blocking = true
	velocity.x = 0.0
	print("Enemy puts block up")
	_set_outline(sprite, true, Color(0.2, 0.55, 1.0))
	sprite.play(&"Idle")
	await get_tree().create_timer(0.4).timeout

func take_turn() -> void:
	_set_outline(sprite, false)
	is_blocking = false
	if sprite.animation == &"Hit":
		await sprite.animation_finished
	if is_dead:
		return
	var player = get_tree().get_first_node_in_group("Player")
	if player == null or player.is_dead:
		return
		
	var player_position: Vector2 = player.global_position
	var direction: float = sign(player_position.x - global_position.x)
	if global_position.distance_to(player_position) > attack_range:
		await _move_once(direction)
	elif randf() < block_chance:
		await _play_block()
	else:
		await _play_attack()
	
func _reset_invincibility() -> void:
	await get_tree().create_timer(0.2).timeout
	is_invincible = false

func _end_attack() -> void:
	if attack_area and attack_area.has_method("end_attack"):
		attack_area.end_attack()

func _set_animation_loop(anim_name: StringName, should_loop: bool) -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(anim_name):
		sprite.sprite_frames.set_animation_loop(anim_name, should_loop)
