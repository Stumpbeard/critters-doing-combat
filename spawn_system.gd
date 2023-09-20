extends Control

var screen_height

@export var spawn_timer_speed = 1.0
@export var heat_bar_speed = 0.1

var heat_ratio = 0.0

signal spawn_enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_height = get_viewport().get_visible_rect().size.y
	var converted_heat_ratio = screen_height * heat_ratio
	$HeatBarFill.size.y = converted_heat_ratio
	$HeatBarFill.position.y -= converted_heat_ratio
	$HeatBarFill/HeatBar.position.y += converted_heat_ratio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$SpawnTimerFill.size.y += spawn_timer_speed
	$HeatBarFill.size.y += heat_bar_speed
	$HeatBarFill.position.y -= heat_bar_speed
	$HeatBarFill/HeatBar.position.y += heat_bar_speed
	
	if $SpawnTimerFill.size.y + $HeatBarFill.size.y >= screen_height:
		reset_spawn()
		
		
func reset_spawn():
	$SpawnTimerFill.size.y = 0.0
	emit_signal("spawn_enemy")


func reduce_heat():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($HeatBarFill, "size:y", $HeatBarFill.size.y/2, 1.0)
	tween.tween_property($HeatBarFill, "position:y", screen_height-(screen_height-$HeatBarFill.position.y)/2, 1.0)
	tween.tween_property($HeatBarFill/HeatBar, "position:y", -screen_height+(screen_height+$HeatBarFill/HeatBar.position.y)/2, 1.0)


func get_heat_ratio():
	return $HeatBarFill.size.y / screen_height
	
func set_heat_ratio(ratio):
	heat_ratio = ratio
