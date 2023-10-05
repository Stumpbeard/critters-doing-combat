extends Control

signal start_game

var started = false


# Called when the node enters the scene tree for the first time.
func _ready():
	jump()


func jump():
	var tween = create_tween()
	tween.tween_property($HoppingRatler, "position:y", $HoppingRatler.position.y - 16, 0.1)
	tween.tween_property($HoppingRatler, "position:y", $HoppingRatler.position.y, 0.1)
	tween.tween_interval(0.5)
	tween.tween_callback(jump)

	var other_tween = create_tween()
	var roll = randi() % 2
	if roll == 0:
		other_tween.tween_property(
			$HoppingRatler, "position:x", $HoppingRatler.position.x + 16, 0.2
		)
		$HoppingRatler.flip_h = false
	else:
		other_tween.tween_property(
			$HoppingRatler, "position:x", $HoppingRatler.position.x - 16, 0.2
		)
		$HoppingRatler.flip_h = true


func _input(event):
	if started:
		return
	if event is InputEventMouseButton:
		if !event.pressed:
			emit_signal("start_game")
			started = true
			Global.play_enter()
