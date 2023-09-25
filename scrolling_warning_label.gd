extends Sprite2D


# Called when the node enters the scene tree for the first time.
func play(reverse=false):
	if reverse:
		create_tween().tween_property(self, "offset:x", -1152, 3.0)
		await get_tree().create_timer(3.0).timeout
		offset.x = 0
	else:
		create_tween().tween_property(self, "offset:x", 1152, 3.0)
		await get_tree().create_timer(3.0).timeout
		offset.x = 0
