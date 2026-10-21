extends CharacterBody2D

const TILE_SIZE = 64
var move_cooldown = 0.0 

@onready var attack_collision = $AttackArea/CollisionShape2D
@onready var sprite = $Sprite2D
var attack_texture = preload("res://Art/ATTACK 1.png")
var default_texture 

func _ready():
	default_texture = sprite.texture

func _physics_process(delta: float) -> void:
	# constantly decrease time
	if move_cooldown > 0:
		move_cooldown -= delta
		
	# attack
	if Input.is_action_just_pressed("attack"):
		attack_collision.disabled = false
		sprite.texture = attack_texture
		await get_tree().create_timer(0.2).timeout
		attack_collision.disabled = true
		sprite.texture = default_texture

	var move_dir = Vector2.ZERO
	
	# accept only when cooldown time is 0
	if move_cooldown <= 0:
		# while pressing the character moves
		if Input.is_action_pressed("right"):
			move_dir.x = 1
		elif Input.is_action_pressed("left"):
			move_dir.x = -1
		elif Input.is_action_pressed("down"):
			move_dir.y = 1
		elif Input.is_action_pressed("up"):
			move_dir.y = -1
			
	if move_dir != Vector2.ZERO:
		position += move_dir * TILE_SIZE
		move_cooldown = 0.15 # after move, limit the next input (change this to control the movement)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
