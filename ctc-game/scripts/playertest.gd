extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

var is_busy := false
var facing_left := false


func _ready() -> void:
	add_to_group("Player")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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


func _move_once(direction: float) -> void:
	is_busy = true
	animated_sprite.play(&"Move")
	velocity.x = direction * SPEED
	await _wait_for_animation(&"Move")
	velocity.x = 0.0
	_play_idle()
	is_busy = false


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
