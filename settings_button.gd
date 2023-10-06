extends Area2D

signal button_pressed

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			emit_signal("button_pressed")
			get_viewport().set_input_as_handled()
