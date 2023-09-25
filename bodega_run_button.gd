extends Area2D

signal bodega_button_pressed



func _on_mouse_entered():
	$Sprite2D.rotation_degrees = -10


func _on_mouse_exited():
	$Sprite2D.rotation_degrees = 0


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			emit_signal("bodega_button_pressed")
