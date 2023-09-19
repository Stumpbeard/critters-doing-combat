extends "res://rotate_action_button.gd"

signal chill_pressed

func action():
	emit_signal("chill_pressed")
