extends Sprite2D

var base_width
var base_height
var button_ready = false

@export var recharge_rate = 3.0


# Called when the node enters the scene tree for the first time.
func _ready():
	base_width = texture.get_width()
	base_height = texture.get_height()
	$Fill.size = Vector2(base_width, base_height)
	$Fill.position = Vector2(base_width/-2, base_height/-2)
	$Fill/FilledButton.position = $Fill.position * -1
	trigger_fill()
	


func trigger_fill():
	button_ready = false
	$Fill.size.x = 0
	var tween = create_tween()
	tween.tween_property($Fill, "size:x", base_width, recharge_rate)
	tween.tween_callback(ready_button)

func ready_button():
	button_ready = true


func _on_activation_area_mouse_entered():
	rotation_degrees = -10
	$ActivationArea.rotation_degrees = 10


func _on_activation_area_mouse_exited():
	rotation_degrees = 0
	$ActivationArea.rotation_degrees = 0


func _on_activation_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && button_ready:
			trigger_fill()
			action()
			
func action():
	return
