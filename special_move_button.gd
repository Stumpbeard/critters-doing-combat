extends "res://rotate_action_button.gd"

signal moves_pressed


func _ready():
	super._ready()
	trigger_fill()
	
	
func _physics_process(delta):
	if $Fill.size.x >= base_width * 0.8:
		button_ready = true

func action():
	emit_signal("moves_pressed")

func _on_activation_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && button_ready:
			button_ready = false
			$Fill.size.x = 0
			action()
			if fill_tween:
				fill_tween.kill()
