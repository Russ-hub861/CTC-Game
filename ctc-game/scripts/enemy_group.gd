extends CharacterBody2D
class_name EnemyGroup

@export var max_health: int = 5
@export var speed: float = 100.0
@export var attack_range: float = 250.0
var health: int 
var is_dead: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _hit_serial := 0

func _ready() -> void:
	add_to_group("Enemies")
	health = max_health
	if sprite == null:
		return
	_set_animation_loop(&"Hit", false)
	_set_animation_loop(&"Death", false)
	sprite.play(&"Idle")

func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount

	if sprite == null:
		if health <= 0:
			is_dead = true
			queue_free()
		return

	if health <= 0:
		is_dead = true
		_hit_serial += 1
		sprite.play(&"Death")
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
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Stay still while hurt, dead, or if this node has no sprite.
	if is_dead or sprite == null or sprite.animation == &"Hit" or sprite.animation == &"Death":
		velocity.x = 0
		move_and_slide()
		return

	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		velocity.x = 0
		move_and_slide()
		return

	# Face the player and walk toward them until we are close enough to attack.
	var player_position: Vector2 = player.global_position
	sprite.flip_h = player_position.x < global_position.x

	if global_position.distance_to(player_position) > attack_range:
		var direction: float = sign(player_position.x - global_position.x)
		velocity.x = direction * speed
		if sprite.animation != &"Idle":
			sprite.play(&"Idle")
	else:
		velocity.x = 0
		var attack_name := &"Attack"
		if not sprite.sprite_frames.has_animation(attack_name):
			attack_name = &"BasicAttack"
		if sprite.animation != attack_name:
			sprite.play(attack_name)

	move_and_slide()

func _set_animation_loop(anim_name: StringName, should_loop: bool) -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(anim_name):
		sprite.sprite_frames.set_animation_loop(anim_name, should_loop)
