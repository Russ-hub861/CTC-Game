extends CharacterBody2D

@export var max_health: int = 5
@export var SPEED: float = 100.0
@export var attack_range: float = 250.0
var health: int 
var is_dead: bool = false
signal died
signal health_changed(new_health)
signal turn_finished

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

var _hit_serial := 0
var is_busy := false
var facing_left := false

var can_control: bool = false

func _ready() -> void:
	add_to_group("Player")
	health = max_health
	# appear from the middle of the gate
	var spawn_x = 190.0
	var target_x = position.x # 579.0 will be auto filled
	
	start_entrance_walk(spawn_x, target_x)

func start_entrance_walk(spawn_x: float, target_x: float) -> void:
	can_control = false
	position.x = spawn_x
	modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	
	# *0.65
	var entrance_speed_scale: float = 0.65
	
	while position.x < target_x - 40.0:
		await _move_once(1.0, entrance_speed_scale, false)
	
	position.x = target_x
	_play_idle()
	can_control = true


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Block input and custom movement during the entrance cutscene
	if not can_control:
		move_and_slide()
		return

	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("ui_up"):
		_flip_facing()

	if not is_busy:
		var direction := _tapped_direction()
		if direction != 0.0:
			_move_once(direction)
		elif Input.is_action_just_pressed("attack"):
			_play_attack()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _flip_facing() -> void:
	facing_left = not facing_left
	_apply_facing()


func _tapped_direction() -> float:
	var left_tapped := Input.is_action_just_pressed("left") or Input.is_action_just_pressed("ui_left")
	var right_tapped := Input.is_action_just_pressed("right") or Input.is_action_just_pressed("ui_right")
	if left_tapped == right_tapped:
		return 0.0
	return -1.0 if left_tapped else 1.0


# ignore the value when default movement
func _move_once(direction: float, speed_multiplier: float = 1.0, ends_turn: bool = true) -> void:
	is_busy = true
	facing_left = direction < 0.0
	_apply_facing()
	
	# as following speed rate, change showing rate of animation
	animated_sprite.speed_scale = speed_multiplier
	animated_sprite.play(&"Move")
	
	velocity.x = direction * (SPEED * speed_multiplier)
	await _wait_for_animation(&"Move")
	velocity.x = 0.0
	
	# set to 1.0
	animated_sprite.speed_scale = 1.0
	_play_idle()
	is_busy = false
	if ends_turn:
		turn_finished.emit()
	
func take_damage(amount: int) -> void:
	if is_dead:
		return
		
	health -= amount
	health_changed.emit(health)
	print("Player health: ", health)
	
	if health <= 0:
		is_dead = true
		is_busy = true
		velocity = Vector2.ZERO
		animated_sprite.play(&"Death")
		await animated_sprite.animation_finished
		player_death()
		return

	_hit_serial += 1
	var serial := _hit_serial
	animated_sprite.play(&"Hit")
	animated_sprite.frame = 0
	animated_sprite.frame_progress = 0.0
	await animated_sprite.animation_finished

	if not is_dead and serial == _hit_serial:
		animated_sprite.play(&"Idle")
		
func player_death() -> void:
	died.emit()


func _play_attack() -> void:
	is_busy = true
	velocity.x = 0.0
	_apply_facing()
	animated_sprite.play(&"basicAttack")
	attack_area.start_attack()
	await _wait_for_animation(&"basicAttack")
	attack_area.end_attack()
	_play_idle()
	is_busy = false
	turn_finished.emit()


func _apply_facing() -> void:
	animated_sprite.flip_h = facing_left
	# AttackArea's shape sits to the right of the player. Flip it with facing.
	attack_area.scale.x = -1.0 if facing_left else 1.0


func _play_idle() -> void:
	#animated_sprite.flip_h = facing_left
	animated_sprite.play(&"Idle")


func _wait_for_animation(anim_name: StringName) -> void:
	var frames := animated_sprite.sprite_frames
	var speed := frames.get_animation_speed(anim_name) * animated_sprite.speed_scale
	if speed <= 0.0:
		return
	await get_tree().create_timer(frames.get_frame_count(anim_name) / speed).timeout

func _play_move():
	animated_sprite.play(&"Move")
