extends Control

var city_level_scene: PackedScene = preload("res://city_area.tscn")
var pizza_level_scene: PackedScene = preload("res://pizza_area.tscn")
var bridge_level_scene: PackedScene = preload("res://bridge_area.tscn")
var subway_scene: PackedScene = preload("res://map_screen.tscn")

var battle_scene = null
var map_scene = null

var kills = {}
var heat_ratios = {
	"city": 0.0,
	"bridge": 0.0,
	"pizzeria": 0.0
}


func accumulate_kills(new_kills):
	for kill in new_kills:
		if kill in kills:
			kills[kill] += new_kills[kill]
		else:
			kills[kill] = new_kills[kill]


func _on_intro_screen_start_game():
	var city_level = city_level_scene.instantiate()
	city_level.connect("battle_over", _on_battle_to_subway)
	add_child(city_level)
	battle_scene = city_level
	$IntroScreen.queue_free()

func _on_battle_to_subway(from, heat_ratio):
	var heat_ratio_diff = heat_ratio - heat_ratios[from]
	heat_ratios[from] = min(1.0, heat_ratio)
	for heat in heat_ratios:
		if heat == from:
			continue
		heat_ratios[heat] = max(0.0, heat_ratios[heat] - heat_ratio_diff / 2.0)
	var subway_map = subway_scene.instantiate()
	subway_map.connect("arrived_at_destination", _on_arrived_at_destination)
	subway_map.set_current_location(from)
	subway_map.set_heat_ratios(heat_ratios)
	add_child(subway_map)
	map_scene = subway_map
	kills = battle_scene.get_enemies_killed()
	battle_scene.queue_free()



func _on_arrived_at_destination(dest):
	match dest:
		"pizzeria":
			var level = pizza_level_scene.instantiate()
			level.connect("battle_over", _on_battle_to_subway)
			level.set_heat_ratio(heat_ratios[dest])
			add_child(level)
			battle_scene = level
			map_scene.queue_free()
		"city":
			var level = city_level_scene.instantiate()
			level.connect("battle_over", _on_battle_to_subway)
			level.set_heat_ratio(heat_ratios[dest])
			add_child(level)
			battle_scene = level
			map_scene.queue_free()
		"bridge":
			var level = bridge_level_scene.instantiate()
			level.connect("battle_over", _on_battle_to_subway)
			level.set_heat_ratio(heat_ratios[dest])
			add_child(level)
			battle_scene = level
			map_scene.queue_free()
	battle_scene.set_enemies_killed(kills)
