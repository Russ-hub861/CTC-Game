extends CharacterBody2D

const TILE_SIZE = 64
var move_cooldown = 0.0 
var can_control: bool = false

@onready var attack_collision = $AttackArea/CollisionShape2D
@onready var sprite = $Sprite2D
#var attack_texture = preload("res://Art/ATTACK 1.png")
var default_texture 

func _ready() -> void:
	if sprite:
		default_texture = sprite.texture
	print("--- PLAYER READY STARTED ---")
	# appear from the middle of the gate
	var spawn_x = 190.0
	var target_x = position.x # 579.0 will be auto filled
	
	start_entrance_walk(spawn_x, target_x)

func start_entrance_walk(spawn_x: float, target_x: float) -> void:
	can_control = false
	position.x = spawn_x
	modulate.a = 0.0 # covered by gate's shadow
	
	if sprite:
		sprite.flip_h = false # toward right
		# show walking animation

	var tween = create_tween()
	tween.set_parallel(true)
	
	# move to default position
	tween.tween_property(self, "position:x", target_x, 1.4).set_trans(Tween.TRANS_LINEAR)
	# appear
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
	await tween.finished
	
	# stop and enable to move
	if sprite:
		sprite.texture = default_texture # or sprite.play("Idle")
	can_control = true

func _physics_process(delta: float) -> void:
	if not can_control:
		if not is_on_floor():
			velocity.y += get_gravity().y * delta
			move_and_slide()
		return
		
	# constantly decrease time
	if move_cooldown > 0:
		move_cooldown -= delta
		
	# attack
	if Input.is_action_just_pressed("attack"):
		attack_collision.disabled = false
		#sprite.texture = attack_texture
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
