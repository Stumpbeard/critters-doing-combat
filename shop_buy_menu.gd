extends Sprite2D

signal bought_heal
signal bought_hp
signal bought_strength
signal bought_speed

@export var level_up_info = {"level": 1, "to_next_level": 1, "hp": 0, "strength": 0, "speed": 0, "kill_dollars": 0}
@export var heals = 0

var player_type = "Ratler"

var exploding_number_scene = preload("res://exploding_number.tscn")

var ratler_scene = preload("res://ratler.tscn")
var pidgepodge_scene = preload("res://pidge_podge.tscn")
var coffeeny_scene = preload("res://coffeeny.tscn")

var starting_hp = 0
var starting_dam_min = 0
var starting_dam_max = 0
var starting_attack_delay = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var critter
	match player_type:
		"Ratler":
			critter = ratler_scene.instantiate()
		"PidgePodge":
			critter = pidgepodge_scene.instantiate()
		"Coffeeny":
			critter = coffeeny_scene.instantiate()
	starting_hp = critter.max_health
	starting_dam_min = critter.damage_value[0]
	starting_dam_max = critter.damage_value[1]
	starting_attack_delay = critter.attack_speed
			
	$HealsHave.text = "x%s" % [heals]
	$HealthUpCost.text = "%s" % [1 + level_up_info["hp"]]
	$HealthUpHave.text = "%s" % [starting_hp + level_up_info["hp"]]
	var dam_range = calc_strength(starting_dam_min, starting_dam_max)
	$DamageUpHave.text = "%s-%s" % [dam_range[0], dam_range[1]]
	$DamageUpCost.text = "%s" % [1 + level_up_info["strength"]]
	var attacks_per_second = make_speed_str(1.0 / (starting_attack_delay - level_up_info['speed'] * 0.02))
	$SpeedUpHave.text = "%s/s" % [attacks_per_second]
	$SpeedUpCost.text = "%s" % [1 + level_up_info["speed"]]
	$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]
	$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
	
	$Selector.visible = false
	
func set_player_type(new_player_type):
	player_type = new_player_type

func calc_strength(dam_min, dam_max):
	var strength_ups = level_up_info["strength"]
	var damage_value = [dam_min, dam_max]
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
		split_string[1] = split_string[1].substr(0, 1)
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
				Global.play_chaching()
				heals += 1
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				$HealsHave.text = "x%s" % [heals]
				emit_signal("bought_heal")
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
			else:
				Global.play_error()


func _on_health_select_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if level_up_info["kill_dollars"] >= 1:
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				emit_signal("bought_hp")
				$HealthUpCost.text = "%s" % [1 + level_up_info["hp"]]
				$HealthUpHave.text = "%s" % [starting_hp + level_up_info["hp"]]
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
				$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]
				


func _on_damage_select_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if level_up_info["kill_dollars"] >= 1:
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				emit_signal("bought_strength")
				var dam_range = calc_strength(starting_dam_min, starting_dam_max)
				$DamageUpHave.text = "%s-%s" % [dam_range[0], dam_range[1]]
				$DamageUpCost.text = "%s" % [1 + level_up_info["strength"]]
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
				$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]


func _on_speed_select_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			if level_up_info["kill_dollars"] >= 1:
				var exploding_number = exploding_number_scene.instantiate()
				exploding_number.number = 1
				add_child(exploding_number)
				exploding_number.global_position = $KillsToSpend.global_position + Vector2(100, 0)
				emit_signal("bought_speed")
				var attacks_per_second = make_speed_str(1.0 / (starting_attack_delay - level_up_info['speed'] * 0.02))
				$SpeedUpHave.text = "%s/s" % [attacks_per_second]
				$SpeedUpCost.text = "%s" % [1 + level_up_info["speed"]]
				$KillsToSpend.text = "Kills: %s" % [level_up_info["kill_dollars"]]
				$TotalLevel.text = "Lv%s" % [1 + level_up_info["hp"] + level_up_info["strength"] + level_up_info["speed"]]


func _on_moves_select_mouse_entered():
	if !$Selector.visible:
		$Selector.position = Vector2(-222, 199)
		$Selector.visible = true
	else:
		create_tween().tween_property($Selector, "position", Vector2(-222, 199), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_moves_select_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && event.button_index == 1:
			Global.play_click()
			if !$ShopMovesBox.visible:
				$ShopMovesBox.visible = true
				create_tween().tween_property($ShopMovesBox, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			else:
				var tween = create_tween()
				tween.tween_property($ShopMovesBox, "scale", Vector2(0, 0), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
				tween.tween_callback($ShopMovesBox.set_visible.bind(false))
