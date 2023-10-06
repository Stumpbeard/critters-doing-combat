extends Sprite2D

signal slider_value_changed

@export var percent = 70

var grabbed = false


func _ready():
	$PercentText.text = "%s%%" % [round(percent)]
	var img_width = get_rect().size.x
	$FillClip.size.x = img_width * (percent / 100.0)
	$Grabber.position.x = img_width * (percent / 100.0)


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		if grabbed:
			$Grabber.global_position.x = get_viewport().get_mouse_position().x
			$Grabber.position.x = clamp($Grabber.position.x, 0, get_rect().size.x)
			$FillClip.size.x = $Grabber.position.x
			var img_width = get_rect().size.x
			percent = $Grabber.position.x / img_width * 100
			$PercentText.text = "%s%%" % [round(percent)]
			emit_signal("slider_value_changed", percent)


func _on_grabber_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		grabbed = event.pressed
		if grabbed:
			Global.play_click()
		$Grabber.global_position.x = get_viewport().get_mouse_position().x
		$Grabber.position.x = clamp($Grabber.position.x, 0, get_rect().size.x)
		$FillClip.size.x = $Grabber.position.x
		var img_width = get_rect().size.x
		percent = $Grabber.position.x / img_width * 100
		$PercentText.text = "%s%%" % [round(percent)]
		emit_signal("slider_value_changed", percent)
	if event is InputEventMouseMotion:
		if grabbed:
			$Grabber.global_position.x = get_viewport().get_mouse_position().x
			$Grabber.position.x = clamp($Grabber.position.x, 0, get_rect().size.x)
			$FillClip.size.x = $Grabber.position.x
			var img_width = get_rect().size.x
			percent = $Grabber.position.x / img_width * 100
			$PercentText.text = "%s%%" % [round(percent)]
			emit_signal("slider_value_changed", percent)


func _on_area_2d_mouse_exited():
	grabbed = false
