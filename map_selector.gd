extends Sprite2D

signal map_button_clicked

@export var heat_ratio = 0.0


func _ready():
	$Bubble.scale = Vector2(0, 0)
	$HeatMeter.value = heat_ratio * 100


func _on_mouse_area_mouse_entered():
	var tween = create_tween()
	(
		tween
		. tween_property($Bubble, "scale", Vector2(1, 1), 0.2)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)


func _on_mouse_area_mouse_exited():
	var tween = create_tween()
	tween.tween_property($Bubble, "scale", Vector2(0, 0), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(
		Tween.EASE_IN
	)
	await get_tree().create_timer(0.2).timeout


func _on_mouse_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			emit_signal("map_button_clicked")
