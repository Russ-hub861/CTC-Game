extends CanvasLayer

@onready var main_panel = $CenterContainer/PanelContainer/MainPanel
@onready var confirm_panel = $CenterContainer/PanelContainer/ConfirmPanel

# MainPanel
@onready var total_exp_label = $CenterContainer/PanelContainer/MainPanel/StatusArea/TotalExpLabel
@onready var level_label = $CenterContainer/PanelContainer/MainPanel/StatusArea/LevelLabel
@onready var exp_bar = $CenterContainer/PanelContainer/MainPanel/StatusArea/ExpBar

# ConfirmPanel
@onready var name_label = $CenterContainer/PanelContainer/ConfirmPanel/SkillNameLabel
@onready var desc_label = $CenterContainer/PanelContainer/ConfirmPanel/SkillDescLabel
@onready var preview_label = $CenterContainer/PanelContainer/ConfirmPanel/PreviewLabel
@onready var confirm_btn = $CenterContainer/PanelContainer/ConfirmPanel/Buttons/ConfirmBtn
@onready var cancel_btn = $CenterContainer/PanelContainer/ConfirmPanel/Buttons/CancelBtn

var skill_data = {
	1: {"name": "Thruster", "cost": 50, "desc": "Block with Attack OR Move"},
	2: {"name": "Charge Attack", "cost": 80, "desc": "Hit both sides for 4 damage"},
	3: {"name": "Heal", "cost": 30, "desc": "Regen HP"}
}

var current_selected_skill_id = 0
var player_ref = null

func _ready():
	visible = false
	confirm_panel.visible = false
	main_panel.visible = true
	
	confirm_btn.pressed.connect(_on_confirm_pressed)
	cancel_btn.pressed.connect(_on_cancel_pressed)
	
	var skill_list = $CenterContainer/PanelContainer/MainPanel/SkillList
	skill_list.get_node("Skill1/UnlockBtn1").pressed.connect(func(): _show_confirm(1))
	skill_list.get_node("Skill2/UnlockBtn2").pressed.connect(func(): _show_confirm(2))
	skill_list.get_node("Skill3/UnlockBtn3").pressed.connect(func(): _show_confirm(3))

func _input(event):
	if event.is_action_pressed("toggle_skill_menu"):
		toggle_menu()

func toggle_menu():
	visible = !visible
	get_tree().paused = visible
	
	if visible:
		# get a player node
		player_ref = get_tree().get_first_node_in_group("Player")
		_update_main_ui()
		main_panel.visible = true
		confirm_panel.visible = false

func _update_main_ui():
	if not player_ref: return
	
	total_exp_label.text = "Total exp points: " + str(player_ref.total_exp) + " (SP: " + str(player_ref.skill_points) + ")"
	level_label.text = "Level: " + str(player_ref.level)
	
	exp_bar.max_value = player_ref.exp_to_next_level 
	exp_bar.value = player_ref.current_exp

	# check each conditions of unlocking
	var skill_list = $CenterContainer/PanelContainer/MainPanel/SkillList
	
	# skill1
	var btn1 = skill_list.get_node("Skill1/UnlockBtn1")
	if player_ref.unlocked_double_action:
		btn1.text = "Unlocked"
		btn1.disabled = true
	else:
		btn1.text = "Unlock"
		btn1.disabled = false

	# skill2
	var btn2 = skill_list.get_node("Skill2/UnlockBtn2")
	if player_ref.unlocked_long_attack:
		btn2.text = "Unlocked"
		btn2.disabled = true
	else:
		btn2.text = "Unlock"
		btn2.disabled = false

	# skill3
	var btn3 = skill_list.get_node("Skill3/UnlockBtn3")
	if player_ref.unlocked_heal:
		btn3.text = "Unlocked"
		btn3.disabled = true
	else:
		btn3.text = "Unlock"
		btn3.disabled = false

func _show_confirm(skill_id):
	current_selected_skill_id = skill_id
	var data = skill_data[skill_id]
	
	# divide each Labels of description and Name
	name_label.text = data["name"]
	desc_label.text = data["desc"]
	
	var current_sp = player_ref.skill_points
	var cost = data["cost"]
	var after_sp = current_sp - cost
	
	# if point is enough
	if after_sp < 0:
		preview_label.text = "Not enough EXP\nNeed: " + str(cost) + " / Current SP: " + str(current_sp)
		preview_label.add_theme_color_override("font_color", Color.RED) # if not enough, RED
		confirm_btn.disabled = true
	else:
		preview_label.text = "You can UNLOCK\nCost SP: " + str(cost) + "\nSP: " + str(current_sp) + " -> " + str(after_sp)
		preview_label.add_theme_color_override("font_color", Color.GREEN) # if enough, GREEN
		confirm_btn.disabled = false
	
	main_panel.visible = false
	confirm_panel.visible = true

func _on_cancel_pressed():
	confirm_panel.visible = false
	main_panel.visible = true

func _on_confirm_pressed():
	if current_selected_skill_id == 0 or not player_ref: return
	
	var cost = skill_data[current_selected_skill_id]["cost"]
	# refer to skill_points
	if player_ref.skill_points >= cost:
		player_ref.skill_points -= cost
		
		match current_selected_skill_id:
			1: player_ref.unlocked_double_action = true
			2: player_ref.unlocked_long_attack = true
			3: player_ref.unlocked_heal = true
		
		print(skill_data[current_selected_skill_id]["name"] + "is UNLOCKED")
		
		_update_main_ui()
		confirm_panel.visible = false
		main_panel.visible = true
