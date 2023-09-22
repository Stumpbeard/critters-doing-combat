extends Control

signal arrived_at_destination

enum Places { CITY, PIZZERIA, BRIDGE }

@export var player_at: Places = Places.CITY
@export var heat_ratios = {"city": 0.0, "bridge": 0.0, "pizzeria": 0.0}

var player_traveling = false


func _ready():
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
