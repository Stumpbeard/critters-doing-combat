extends Control

var city_level_scene: PackedScene = preload("res://city_area.tscn")
var pizza_level_scene: PackedScene = preload("res://pizza_area.tscn")
var bridge_level_scene: PackedScene = preload("res://bridge_area.tscn")
var subway_scene: PackedScene = preload("res://map_screen.tscn")
var bodega_scene: PackedScene = preload("res://shop.tscn")

var battle_scene = null
var map_scene = null
var shop_scene = null

var kills = {}
var heat_ratios = {"city": 0.0, "bridge": 0.0, "pizzeria": 0.0}
var heals = 1

var coming_from = ''

var level_up_info = {"level": 1, "to_next_level": 1, "hp": 0, "strength": 0, "speed": 0, "kill_dollars": 0}


func _on_intro_screen_start_game():
	create_tween().tween_property($BlackFade, "color:a", 1.0, 0.2)
	await get_tree().create_timer(0.2).timeout
	var city_level = city_level_scene.instantiate()
	city_level.connect("battle_over", _on_battle_to_subway)
	city_level.get_node("BattleBox").connect("heal_used", _on_heal_used)
	add_child(city_level)
	battle_scene = city_level
	$IntroScreen.queue_free()
	create_tween().tween_property($BlackFade, "color:a", 0.0, 0.2)
	
func _on_heal_used():
	heals = max(0, heals - 1)


func _on_battle_to_subway(from, heat_ratio):
	create_tween().tween_property($BlackFade, "color:a", 1.0, 0.2)
	await get_tree().create_timer(0.2).timeout
	coming_from = from
	var heat_ratio_diff = heat_ratio - heat_ratios[from]
	heat_ratios[from] = min(1.0, heat_ratio)
	for heat in heat_ratios:
		if heat == from:
			continue
		heat_ratios[heat] = max(0.0, heat_ratios[heat] - heat_ratio_diff / 2.0)
	var subway_map = subway_scene.instantiate()
	subway_map.connect("arrived_at_destination", _on_arrived_at_destination)
	subway_map.connect("go_to_bodega", _on_go_to_bodega)
	subway_map.set_current_location(from)
	subway_map.set_heat_ratios(heat_ratios)
	add_child(subway_map)
	map_scene = subway_map
	kills = battle_scene.get_enemies_killed()
	level_up_info = battle_scene.get_level_info()
	battle_scene.queue_free()
	create_tween().tween_property($BlackFade, "color:a", 0.0, 0.2)


func _on_arrived_at_destination(dest):
	create_tween().tween_property($BlackFade, "color:a", 1.0, 0.2)
	await get_tree().create_timer(0.2).timeout
	var level = null
	match dest:
		"pizzeria":
			level = pizza_level_scene.instantiate()
		"city":
			level = city_level_scene.instantiate()
		"bridge":
			level = bridge_level_scene.instantiate()
	level.connect("battle_over", _on_battle_to_subway)
	level.set_heat_ratio(heat_ratios[dest])
	battle_scene = level
	battle_scene.set_enemies_killed(kills)
	battle_scene.set_player_info(level_up_info, heals)
	add_child(level)
	map_scene.queue_free()
	create_tween().tween_property($BlackFade, "color:a", 0.0, 0.2)
	

func _on_go_to_bodega():
	create_tween().tween_property($BlackFade, "color:a", 1.0, 0.2)
	await get_tree().create_timer(0.2).timeout
	var bodega = bodega_scene.instantiate()
	bodega.get_node("ShopBuyMenu").connect("bought_heal", _on_bought_heal)
	bodega.get_node("ShopBuyMenu").connect("bought_hp", _on_bought_hp)
	bodega.get_node("ShopBuyMenu").connect("bought_strength", _on_bought_strength)
	bodega.get_node("ShopBuyMenu").connect("bought_speed", _on_bought_speed)
	bodega.get_node("LeaveButton").connect("leave_bodega", _on_leave_bodega)
	shop_scene = bodega
	bodega.set_player_info(level_up_info, heals)
	add_child(bodega)
	map_scene.queue_free()
	create_tween().tween_property($BlackFade, "color:a", 0.0, 0.2)
	
	
func _on_leave_bodega():
	create_tween().tween_property($BlackFade, "color:a", 1.0, 0.2)
	await get_tree().create_timer(0.2).timeout
	var subway_map = subway_scene.instantiate()
	subway_map.connect("arrived_at_destination", _on_arrived_at_destination)
	subway_map.connect("go_to_bodega", _on_go_to_bodega)
	subway_map.set_current_location(coming_from)
	subway_map.set_heat_ratios(heat_ratios)
	add_child(subway_map)
	map_scene = subway_map
	shop_scene.queue_free()
	create_tween().tween_property($BlackFade, "color:a", 0.0, 0.2)


func _on_bought_heal():
	heals += 1
	level_up_info["kill_dollars"] -=1

func _on_bought_hp():
	level_up_info["kill_dollars"] -= level_up_info["hp"] + 1
	level_up_info["hp"] += 1
	level_up_info["level"] += 1
	
func _on_bought_strength():
	level_up_info["kill_dollars"] -= level_up_info["strength"] + 1
	level_up_info["strength"] += 1
	level_up_info["level"] += 1
	
func _on_bought_speed():
	level_up_info["kill_dollars"] -= level_up_info["speed"] + 1
	level_up_info["speed"] += 1
	level_up_info["level"] += 1
