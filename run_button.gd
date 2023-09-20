extends "res://rotate_action_button.gd"

signal run_pressed
signal finished_charging
var vibrating = false
var origin_position = Vector2()

var gravity = 144.0 * 8
var velocity = Vector2()
var popping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	base_width = texture.get_width()
	base_height = texture.get_height()
	$Fill.size = Vector2(base_width, base_height)
	$Fill.position = Vector2(base_width/-2, base_height/-2)
	$Fill/FilledButton.position = $Fill.position * -1
	$Fill.size.x = 0.0
	
func _physics_process(delta):
	if popping:
		var movement = Vector2()
		velocity.y = min(0, velocity.y + gravity * delta)
		movement.x = velocity.x
		movement.y += velocity.y
		movement.y += gravity
		position += movement * delta
	elif vibrating:
		var fill_ratio = $Fill.size.x / base_width / 2
		var x_mod = fill_ratio * (72 - randi() % 72)
		var y_mod = fill_ratio * (72 - randi() % 72)
		if origin_position.x <= 0:
			position.x += x_mod
			origin_position.x += x_mod
		else:
			position.x -= x_mod
			origin_position.x -= x_mod
		if origin_position.y <= 0:
			position.y += y_mod
			origin_position.y += y_mod
		else:
			position.y -= y_mod
			origin_position.y -= y_mod
			
		if fill_ratio * 2 >= 1.0:
			velocity.x = randf() * 288.0 - 144.0
			velocity.y = gravity * -(randf() * 0.75 + 1.0)
			popping = true
			emit_signal("finished_charging")

func action():
	if popping || vibrating:
		return
	emit_signal("run_pressed")
	button_ready = false
	trigger_fill()
	vibrating = true
	origin_position = Vector2(0, 0)
