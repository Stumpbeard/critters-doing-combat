extends Sprite2D

signal return_pressed


func _on_return_button_mouse_entered():
	$ReturnButton/TypingText.rotation_degrees = -10


func _on_return_button_mouse_exited():
	$ReturnButton/TypingText.rotation_degrees = 0


func _on_sfx_slider_slider_value_changed(val):
	var new_vol = -6.0
	new_vol += (val/100.0) * 10
	AudioServer.set_bus_volume_db(2, new_vol)
	AudioServer.set_bus_mute(2, is_zero_approx(val))


func _on_return_button_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			emit_signal("return_pressed")


func _on_music_slider_slider_value_changed(val):
	var new_vol = -6
	new_vol += (val/100.0) * 10
	AudioServer.set_bus_volume_db(1, new_vol)
	AudioServer.set_bus_mute(1, is_zero_approx(val))
