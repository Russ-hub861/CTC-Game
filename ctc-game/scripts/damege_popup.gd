extends Label

func show_damage(amount: int, spawn_pos: Vector2, type: String = "enemy_hit") -> void:
	text = str(abs(amount))
	
	# change UI color
	match type:
		"enemy_hit":
			# for enemy
			add_theme_color_override("font_color", Color(1.0, 0.25, 0.25, 1.0))
			add_theme_color_override("font_outline_color", Color(1.0, 1.0, 1.0, 1.0))
		"player_hit":
			# taken damage(player)
			add_theme_color_override("font_color", Color(0.3, 0.7, 1.0, 1.0))
			add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
		"heal":
			# to heal(just in case)
			add_theme_color_override("font_color", Color(0.25, 1.0, 0.35, 1.0))
			add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	
	pivot_offset = size / 2.0
	global_position = spawn_pos - (size / 2.0)
	
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	scale = Vector2(0.5, 0.5)
	
	var tween = create_tween()
	
	# Phase 1: popup
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y - 20.0, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Phase 2: fade out
	tween.chain().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(self, "position:y", position.y - 36.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.25).set_delay(0.1)
	
	await tween.finished
	queue_free()
