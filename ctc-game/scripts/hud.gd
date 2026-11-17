extends CanvasLayer


var max_health = 20
var current_health = 20

@onready var exp_bar: ProgressBar = $ExpBar
@onready var level_label: Label = $LevelLabel

#skill cooldown indication
@onready var skill1_label: Label = $SkillSection/Skill1Label
@onready var skill2_label: Label = $SkillSection/Skill2Label
@onready var skill3_label: Label = $SkillSection/Skill3Label

var ready_color: Color = Color(0.165, 0.727, 0.703, 1.0) 
var cd_color: Color = Color(0.6, 0.6, 0.6) 
var locked_color: Color = Color(0.3, 0.3, 0.3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#update_health(new_health)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#This updates the players health and changes the number of hearts visible
func update_health(new_health: int):
	#current_health = new_health
	var hearts = $VBoxContainer.get_children()

	for row in hearts:
		for heart in row.get_children():
			var index = hearts.find(row) * 10 + row.get_children().find(heart)
			if index < new_health:
				heart.show()
			else:
				heart.hide()


func update_exp(current_exp: int, max_exp: int, level: int) -> void:
	exp_bar.max_value = max_exp
	exp_bar.value = current_exp
	level_label.text = "Lv." + str(level)

func update_cooldowns(thrust_cd: int, aoe_cd: int, heal_cd: int, is_thrust_unlocked: bool, is_aoe_unlocked: bool, is_heal_unlocked: bool) -> void:
	
	# Skill 1: Thruster
	if is_thrust_unlocked:
		if thrust_cd > 0:
			skill1_label.text = "Thruster CD: " + str(thrust_cd)
			skill1_label.add_theme_color_override("font_color", cd_color)
		else:
			skill1_label.text = "Thruster"
			skill1_label.add_theme_color_override("font_color", ready_color)
	else:
		skill1_label.text = "Thruster (Locked)"
		skill1_label.add_theme_color_override("font_color", locked_color)

	# Skill 2: Charge Attack
	if is_aoe_unlocked:
		if aoe_cd > 0:
			skill2_label.text = "Charge CD: " + str(aoe_cd)
			skill2_label.add_theme_color_override("font_color", cd_color)
		else:
			skill2_label.text = "Charge Attack"
			skill2_label.add_theme_color_override("font_color", ready_color)
	else:
		skill2_label.text = "Charge Attack (Locked)"
		skill2_label.add_theme_color_override("font_color", locked_color)
		
	# Skill 3: Heal 
	if is_heal_unlocked:
		if heal_cd > 0:
			skill3_label.text = "Heal CD: " + str(heal_cd)
			skill3_label.add_theme_color_override("font_color", cd_color)
		else:
			skill3_label.text = "Heal"
			skill3_label.add_theme_color_override("font_color", ready_color)
	else:
		skill3_label.text = "Heal (Locked)"
		skill3_label.add_theme_color_override("font_color", locked_color)
		
