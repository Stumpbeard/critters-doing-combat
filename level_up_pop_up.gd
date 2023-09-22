extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	intro_animation()


func intro_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.4).set_trans(Tween.TRANS_ELASTIC)
	(
		tween
		. tween_property(self, "position", position + Vector2(34, -16), 1.0)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_OUT)
	)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	queue_free()
