extends "res://rotate_action_button.gd"

signal heal_pressed

@export var heals = 1


func set_heals(new_heals):
	heals = new_heals

func _ready():
	super._ready()
	$ActivationArea/RemainingHeals.text = "x%s" % [heals]
	if heals > 0:
		trigger_fill()
		
		
func _on_activation_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && button_ready:
			action()
			heals -= 1
			$ActivationArea/RemainingHeals.text = "x%s" % [heals]
			if heals > 0:
				trigger_fill()
			else:
				button_ready = false
				$Fill.size.x = 0

func action():
	emit_signal("heal_pressed")
