extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -300.0

@onready var attack_collision = $AttackArea/CollisionShape2D
@onready var sprite = $Sprite2D

var attack_texture = preload("res://Art/ATTACK 1.png") #effect:attack

var default_texture #default character picture

func _ready():
	default_texture = sprite.texture

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	
	if direction != 0:
		print("movement ditected", direction)
		
	if Input.is_action_just_pressed("attack"):
		attack_collision.disabled = false
		sprite.texture = attack_texture # change to attack 1 png.
		
		await get_tree().create_timer(0.2).timeout
		
		attack_collision.disabled = true
		sprite.texture = default_texture
		
		await get_tree().create_timer(0.3).timeout
		
		attack_collision.disabled = true
		print("attack ends")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
