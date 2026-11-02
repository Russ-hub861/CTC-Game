extends CharacterBody2D
class_name EnemyGroup

@export var max_health: int = 5
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

func _set_animation_loop(anim_name: StringName, should_loop: bool) -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(anim_name):
		sprite.sprite_frames.set_animation_loop(anim_name, should_loop)
