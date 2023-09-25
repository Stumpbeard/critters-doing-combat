extends Sprite2D

signal bought_heal
signal bought_hp
signal bought_strength
signal bought_speed

@export var level_up_info = {"level": 1, "to_next_level": 1, "hp": 0, "strength": 0, "speed": 0, "kill_dollars": 0}
@export var heals = 0

var exploding_number_scene = preload("res://exploding_number.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealsHave.text = "x%s" % [heals]
	$HealthUpCost.text = "%s" % [1 + level_up_info["hp"]]
	$HealthUpHave.text = "%s" % [10 + level_up_info["hp"]]
	var dam_range = calc_strength()
	$DamageUpHave.text = "%s-%s" % [dam_range[0], dam_range[1]]
	$DamageUpCost.text = "%s" % [1 + level_up_info["strength"]]
	var attacks_per_second = make_speed_str(1.0 / (1.0 - level_up_info['speed'] * 0.1))
	$SpeedUpHave.text = "%s/s" % [attacks_per_second]
	$SpeedUpCost.text = "%s" % [1 + level_up_info["speed"]]
	$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]
	$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
	
	$Selector.visible = false

func calc_strength():
	var strength_ups = level_up_info["strength"]
	var damage_value = [1, 3]
	for i in range(strength_ups):
		damage_value[1] += 1
		if damage_value[1] % 6 == 0:
			damage_value[0] += 1
	return damage_value

func make_speed_str(num):
	var num_string = str(num)
	var split_string = num_string.split('.')
	if len(split_string) <= 1:
		return num_string
	if len(split_string[1]) > 2:
		split_string[1] = split_string[1].substr(0, 2)
	return ".".join(split_string)


func set_player_info(new_level_info, new_heals):
	level_up_info = new_level_info
	heals = new_heals


func _on_heals_select_mouse_entered():
	if !$Selector.visible:
		$Selector.position = Vector2(-222, -113)
		$Selector.visible = true
	else:
		create_tween().tween_property($Selector, "position", Vector2(-222, -113), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_health_select_mouse_entered():
	if !$Selector.visible:
		$Selector.position = Vector2(-161, 28)
		$Selector.visible = true
	else:
		create_tween().tween_property($Selector, "position", Vector2(-161, 28), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_damage_select_mouse_entered():
	if !$Selector.visible:
		$Selector.position = Vector2(-161, 80)
		$Selector.visible = true
	else:
		create_tween().tween_property($Selector, "position", Vector2(-161, 80), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_speed_select_mouse_entered():
	if !$Selector.visible:
		$Selector.position = Vector2(-161, 131)
		$Selector.visible = true
	else:
		create_tween().tween_property($Selector, "position", Vector2(-161, 131), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_heals_select_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if level_up_info["kill_dollars"] > 0:
				heals += 1
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				$HealsHave.text = "x%s" % [heals]
				emit_signal("bought_heal")
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]


func _on_health_select_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if level_up_info["kill_dollars"] >= level_up_info["hp"] + 1:
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = level_up_info["hp"] + 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				emit_signal("bought_hp")
				$HealthUpCost.text = "%s" % [1 + level_up_info["hp"]]
				$HealthUpHave.text = "%s" % [10 + level_up_info["hp"]]
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
				$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]
				


func _on_damage_select_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if level_up_info["kill_dollars"] >= level_up_info["strength"] + 1:
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = level_up_info["strength"] + 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				emit_signal("bought_strength")
				var dam_range = calc_strength()
				$DamageUpHave.text = "%s-%s" % [dam_range[0], dam_range[1]]
				$DamageUpCost.text = "%s" % [1 + level_up_info["strength"]]
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
				$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]


func _on_speed_select_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if level_up_info["kill_dollars"] >= level_up_info["speed"] + 1:
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = level_up_info["speed"] + 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				emit_signal("bought_speed")
				var attacks_per_second = make_speed_str(1.0 / (1.0 - level_up_info['speed'] * 0.1))
				$SpeedUpHave.text = "%s/s" % [attacks_per_second]
				$SpeedUpCost.text = "%s" % [1 + level_up_info["speed"]]
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
				$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]
