extends CharacterBody2D
class_name EnemyGroup

@export var max_health: int = 5
var health: int 
var is_dead: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready(): 
	health = max_health
	sprite.play("Idle")
	
func take_damage(amount: int):
	if is_dead:
		return
		
	health -= amount
	
	if health <= 0:
		is_dead = true
		sprite.play("Death")
		await sprite.animation_finished
		queue_free()
		return
		
	sprite.play("Hit")
	await sprite.animation_finished
	
	if not is_dead: 
		sprite.play("Idle")
