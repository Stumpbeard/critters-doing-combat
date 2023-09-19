extends "res://rotate_action_button.gd"

signal heal_pressed


func action():
	emit_signal("heal_pressed")
