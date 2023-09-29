extends Control

signal spawn_enemy
signal trigger_boss_mode

@export var spawn_timer_speed = 1.0
@export var heat_bar_speed = 0.1

var screen_height

var heat_ratio = 0.0

var in_boss_mode = false

var stopped = false


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_height = get_viewport().get_visible_rect().size.y
	var converted_heat_ratio = screen_height * heat_ratio
	$HeatBarFill.size.y = converted_heat_ratio
	$HeatBarFill.position.y -= converted_heat_ratio
	$HeatBarFill/HeatBar.position.y += converted_heat_ratio
	
	var skull_tween = create_tween()
	skull_tween.set_loops()
	skull_tween.tween_property($BossIndicator, "scale", Vector2(1.3, 1.3), 0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	skull_tween.tween_property($BossIndicator, "scale", Vector2(1.0, 1.0), 0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)


func stop():
	stopped = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if stopped:
		return
	if !in_boss_mode:
		$SpawnTimerFill.size.y += spawn_timer_speed
		$HeatBarFill.size.y = min($HeatBarFill.size.y + heat_bar_speed, screen_height * 0.9)
		$HeatBarFill.position.y = max($HeatBarFill.position.y - heat_bar_speed, screen_height * 0.1)
		$HeatBarFill/HeatBar.position.y = min($HeatBarFill/HeatBar.position.y + heat_bar_speed, screen_height * -0.1)

		if $SpawnTimerFill.size.y + $HeatBarFill.size.y >= screen_height:
			if is_equal_approx($HeatBarFill.size.y, screen_height * 0.9):
				kill_all_enemies_and_spawn_boss()
			else:
				reset_spawn()
		


func kill_all_enemies_and_spawn_boss():
	in_boss_mode = true
	emit_signal("trigger_boss_mode")
	$BossIndicator.visible = true


func reset_spawn():
	$SpawnTimerFill.size.y = 0.0
	emit_signal("spawn_enemy")


func reduce_heat():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($HeatBarFill, "size:y", $HeatBarFill.size.y / 2, 1.0)
	tween.tween_property(
		$HeatBarFill,
		"position:y",
		screen_height - (screen_height - $HeatBarFill.position.y) / 2,
		1.0
	)
	tween.tween_property(
		$HeatBarFill/HeatBar,
		"position:y",
		-screen_height + (screen_height + $HeatBarFill/HeatBar.position.y) / 2,
		1.0
	)


func get_heat_ratio():
	return $HeatBarFill.size.y / screen_height


func set_heat_ratio(ratio):
	heat_ratio = ratio
