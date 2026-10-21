extends CharacterBody2D

var max_hp = 50.0
var hp = max_hp

@onready var health_bar = $"HP bar"
@onready var damage_label = $"damage dealed"

func _ready():
	# set max HP and current HP
	health_bar.max_value = max_hp
	health_bar.value = hp
	damage_label.text = "" # need to be replaced

func take_damage(damage: int):
	hp -= damage
	health_bar.value = hp # update HP bar
	
	# indicate damege dealing
	damage_label.text = "-" + str(damage) 
	
	# make enemy red
	modulate = Color(1, 0, 0) 
	
	print("HIT remaining: ", hp)
	
	# keep indicates the effect
	await get_tree().create_timer(0.2).timeout
	
	# make it default and delete indicator
	modulate = Color(1, 1, 1)
	damage_label.text = ""
	
	# if HP < 0, eliminate
	if hp <= 0:
		print("ELIMINATE")
		queue_free()
