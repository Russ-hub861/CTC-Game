extends CharacterBody2D
class_name EnemyGroup

@export var max_health: int = 5
var health: int
var is_dead: bool = false

# 多重ヒット防止用フラグ
var is_invincible: bool = false

# ダメージポップアップ用シーンの読み込み（パスは保存場所に合わせて調整してください）
const DAMAGE_POPUP_SCENE = preload("res://damege_popup.tscn")

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
	# 死亡済み、または直前のスイング判定持続中ならダメージ処理をスキップ
	if is_dead or is_invincible:
		return

	# 1回の攻撃判定で2重ヒットしないよう一時的に無敵化
	is_invincible = true
	_reset_invincibility()

	health -= amount

	# --- フローティングダメージ数値の生成 ---
	var popup = DAMAGE_POPUP_SCENE.instantiate()
	get_tree().current_scene.add_child(popup)
	
	# Xをマイナス（左へ）、Yをマイナス（上へ）ずらす
	# 例: 左に 24px、上に 48px
	popup.show_damage(amount, global_position + Vector2(70, -55))

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

# 攻撃判定フレーム（約0.15〜0.2秒）の終了後に無敵状態を解除
func _reset_invincibility() -> void:
	await get_tree().create_timer(0.2).timeout
	is_invincible = false

func _set_animation_loop(anim_name: StringName, should_loop: bool) -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(anim_name):
		sprite.sprite_frames.set_animation_loop(anim_name, should_loop)
