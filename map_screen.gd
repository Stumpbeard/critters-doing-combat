extends Control

signal arrived_at_destination
signal go_to_bodega

enum Places { CITY, PIZZERIA, BRIDGE, WALL_ST }

@export var player_at: Places = Places.CITY
@export var heat_ratios = {"city": 0.0, "bridge": 0.0, "pizzeria": 0.0, "wall_st": 0.0}

var player_scene = preload("res://ratler.tscn")

var player_traveling = false


func _ready():
	$CityToPizzaPath/PlayerFollower/Sprite2D.texture = player_scene.instantiate().texture
	$BridgeToCityPath/PlayerFollower/Sprite2D.texture = player_scene.instantiate().texture
	$BridgeToPizzaPath/PlayerFollower/Sprite2D.texture = player_scene.instantiate().texture
	match player_at:
		Places.CITY:
			$CityToPizzaPath/PlayerFollower.visible = true
		Places.BRIDGE:
			$BridgeToCityPath/PlayerFollower.visible = true
		Places.PIZZERIA:
			$CityToPizzaPath/PlayerFollower.visible = true
			$CityToPizzaPath/PlayerFollower.progress_ratio = 1.0


func set_heat_ratios(heat_ratios):
	$PizzeriaMapSelector.heat_ratio = heat_ratios["pizzeria"]
	$CityMapSelector.heat_ratio = heat_ratios["city"]
	$BridgeMapSelector.heat_ratio = heat_ratios["bridge"]


func set_current_location(from):
	match from:
		"city":
			player_at = Places.CITY
		"pizzeria":
			player_at = Places.PIZZERIA
		"bridge":
			player_at = Places.BRIDGE
		"wall_st":
			player_at = Places.WALL_ST


func end_trip(dest = ""):
	player_traveling = false
	emit_signal("arrived_at_destination", dest)


func _on_pizzeria_map_selector_map_button_clicked():
	if player_traveling:
		return
	match player_at:
		Places.CITY:
			$CityToPizzaPath/PlayerFollower.visible = true
			$CityToPizzaPath/PlayerFollower.progress_ratio = 0.0
			$BridgeToCityPath/PlayerFollower.visible = false
			$BridgeToPizzaPath/PlayerFollower.visible = false
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($CityToPizzaPath/PlayerFollower.set_progress_ratio, 0.0, 1.0, 1.0)
			tween.tween_callback(end_trip.bind("pizzeria"))
			player_at = Places.PIZZERIA
		Places.BRIDGE:
			$CityToPizzaPath/PlayerFollower.visible = false
			$BridgeToCityPath/PlayerFollower.visible = false
			$BridgeToPizzaPath/PlayerFollower.visible = true
			$BridgeToPizzaPath/PlayerFollower.progress_ratio = 0.0
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($BridgeToPizzaPath/PlayerFollower.set_progress_ratio, 0.0, 1.0, 1.0)
			tween.tween_callback(end_trip.bind("pizzeria"))
			player_at = Places.PIZZERIA


func _on_city_map_selector_map_button_clicked():
	if player_traveling:
		return
	match player_at:
		Places.BRIDGE:
			$CityToPizzaPath/PlayerFollower.visible = false
			$BridgeToCityPath/PlayerFollower.visible = true
			$BridgeToCityPath/PlayerFollower.progress_ratio = 0.0
			$BridgeToPizzaPath/PlayerFollower.visible = false
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($BridgeToCityPath/PlayerFollower.set_progress_ratio, 0.0, 1.0, 1.0)
			tween.tween_callback(end_trip.bind("city"))
			player_at = Places.CITY
		Places.PIZZERIA:
			$CityToPizzaPath/PlayerFollower.visible = true
			$CityToPizzaPath/PlayerFollower.progress_ratio = 1.0
			$BridgeToCityPath/PlayerFollower.visible = false
			$BridgeToPizzaPath/PlayerFollower.visible = false
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($CityToPizzaPath/PlayerFollower.set_progress_ratio, 1.0, 0.0, 1.0)
			tween.tween_callback(end_trip.bind("city"))
			player_at = Places.CITY


func _on_bridge_map_selector_map_button_clicked():
	if player_traveling:
		return
	match player_at:
		Places.CITY:
			$CityToPizzaPath/PlayerFollower.visible = false
			$BridgeToCityPath/PlayerFollower.visible = true
			$BridgeToCityPath/PlayerFollower.progress_ratio = 1.0
			$BridgeToPizzaPath/PlayerFollower.visible = false
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($BridgeToCityPath/PlayerFollower.set_progress_ratio, 1.0, 0.0, 1.0)
			tween.tween_callback(end_trip.bind("bridge"))
			player_at = Places.BRIDGE
		Places.PIZZERIA:
			$CityToPizzaPath/PlayerFollower.visible = false
			$BridgeToCityPath/PlayerFollower.visible = false
			$BridgeToPizzaPath/PlayerFollower.visible = true
			$BridgeToPizzaPath/PlayerFollower.progress_ratio = 1.0
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($BridgeToPizzaPath/PlayerFollower.set_progress_ratio, 1.0, 0.0, 1.0)
			tween.tween_callback(end_trip.bind("bridge"))
			player_at = Places.BRIDGE


func _on_bodega_run_button_bodega_button_pressed():
	emit_signal("go_to_bodega")


func _on_wall_st_map_selector_map_button_clicked():
	if player_traveling:
		return
	match player_at:
		Places.CITY:
			$CityToPizzaPath/PlayerFollower.visible = false
			$BridgeToCityPath/PlayerFollower.visible = false
			$BridgeToPizzaPath/PlayerFollower.visible = false
			$CityToWallStPath/PlayerFollower.visible = true
			$CityToWallStPath/PlayerFollower.progress_ratio = 0.0
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($CityToWallStPath/PlayerFollower.set_progress_ratio, 0.0, 1.0, 1.0)
			tween.tween_callback(end_trip.bind("wall_st"))
			player_at = Places.WALL_ST
		Places.PIZZERIA:
			$CityToPizzaPath/PlayerFollower.visible = false
			$BridgeToCityPath/PlayerFollower.visible = false
			$BridgeToPizzaPath/PlayerFollower.visible = false
			$PizzaToWallStPath/PlayerFollower.visible = true
			$PizzaToWallStPath/PlayerFollower.progress_ratio = 0.0
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($PizzaToWallStPath/PlayerFollower.set_progress_ratio, 0.0, 1.0, 1.0)
			tween.tween_callback(end_trip.bind("wall_st"))
			player_at = Places.WALL_ST
		Places.BRIDGE:
			$CityToPizzaPath/PlayerFollower.visible = false
			$BridgeToCityPath/PlayerFollower.visible = false
			$BridgeToPizzaPath/PlayerFollower.visible = false
			$BridgeToWallStPath/PlayerFollower.visible = true
			$BridgeToWallStPath/PlayerFollower.progress_ratio = 0.0
			player_traveling = true
			var tween = create_tween()
			tween.tween_method($BridgeToWallStPath/PlayerFollower.set_progress_ratio, 0.0, 1.0, 1.0)
			tween.tween_callback(end_trip.bind("wall_st"))
			player_at = Places.WALL_ST
