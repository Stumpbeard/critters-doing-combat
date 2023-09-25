extends "res://bodega_run_button.gd"

signal leave_bodega

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			emit_signal("leave_bodega")
