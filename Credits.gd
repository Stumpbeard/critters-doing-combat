extends Control

signal credits_finished

var stop = true

var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !stop:
		position.y -= speed
		if $Thanks.global_position.y <= 648/2 - $Thanks.size.y/2:
			stop = true
			emit_signal("credits_finished")
	


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			speed = 4
		elif !event.pressed && event.button_index == 1:
			speed = 1

func start():
	stop = false
