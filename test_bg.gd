extends TextureRect


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_UP:
			create_tween().tween_property(self, "position:y", position.y + 648*2, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		if event.pressed && event.keycode == KEY_DOWN:
			create_tween().tween_property(self, "position:y", position.y - 648*2, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
