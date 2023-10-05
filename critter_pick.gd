extends Control

signal critter_chosen

enum {RATLER, COFFEENY, PIDGEPODGE}

var spinning = false

var top_critter_tween

func set_spinning(val):
	spinning = val

	
func find_top_critter():
	if $Wheel/RatlerSelect.global_position.y < 120:
		$ChosenText.text = "Ratler\nType: Rodent"
		return $Wheel/RatlerSelect/Sprite2D
	if $Wheel/CoffeenySelect.global_position.y < 120:
		$ChosenText.text = "Coffeeny\nType: Trash"
		return $Wheel/CoffeenySelect/Sprite2D
	if $Wheel/PidgePodgeSelect.global_position.y < 120:
		$ChosenText.text = "PidgePodge\nType: Bird"
		return $Wheel/PidgePodgeSelect/Sprite2D


func _physics_process(delta):
	find_top_critter()
	if spinning:
		top_critter_tween.kill()
		$Wheel/RatlerSelect/Sprite2D.offset.y = 0
		$Wheel/CoffeenySelect/Sprite2D.offset.y = 0
		$Wheel/PidgePodgeSelect/Sprite2D.offset.y = 0
		return
	if !top_critter_tween || !top_critter_tween.is_valid():
		top_critter_tween = create_tween()
		top_critter_tween.set_loops()
		top_critter_tween.tween_property(find_top_critter(), "offset:y", -8, 0.05)
		top_critter_tween.tween_property(find_top_critter(), "offset:y", 0, 0.05)
		top_critter_tween.tween_interval(1.0)
			
func spin_one():
	Global.play_swish()
	spinning = true
	var tween = create_tween()
	tween.tween_property($Wheel, "rotation_degrees", $Wheel.rotation_degrees + 120, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property($Wheel/RatlerSelect, "rotation_degrees", $Wheel/RatlerSelect.rotation_degrees - 120, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property($Wheel/CoffeenySelect, "rotation_degrees", $Wheel/CoffeenySelect.rotation_degrees - 120, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property($Wheel/PidgePodgeSelect, "rotation_degrees", $Wheel/PidgePodgeSelect.rotation_degrees - 120, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(set_spinning.bind(false))
	
func spin_two():
	Global.play_swish()
	spinning = true
	var tween = create_tween()
	tween.tween_property($Wheel, "rotation_degrees", $Wheel.rotation_degrees + 240, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property($Wheel/RatlerSelect, "rotation_degrees", $Wheel/RatlerSelect.rotation_degrees - 240, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property($Wheel/CoffeenySelect, "rotation_degrees", $Wheel/CoffeenySelect.rotation_degrees - 240, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property($Wheel/PidgePodgeSelect, "rotation_degrees", $Wheel/PidgePodgeSelect.rotation_degrees - 240, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(set_spinning.bind(false))


func _on_ratler_select_input_event(_viewport, event, _shape_idx):
	if spinning:
		return
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			if $Wheel/RatlerSelect/Sprite2D.global_position.y < 120:
				return
			elif $Wheel/RatlerSelect/Sprite2D.global_position.x < 1152/2:
				spin_one()
			else:
				spin_two()


func _on_coffeeny_select_input_event(_viewport, event, _shape_idx):
	if spinning:
		return
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			if $Wheel/CoffeenySelect/Sprite2D.global_position.y < 120:
				return
			elif $Wheel/CoffeenySelect/Sprite2D.global_position.x < 1152/2:
				spin_one()
			else:
				spin_two()


func _on_pidge_podge_select_input_event(_viewport, event, _shape_idx):
	if spinning:
		return
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			if $Wheel/PidgePodgeSelect/Sprite2D.global_position.y < 120:
				return
			elif $Wheel/PidgePodgeSelect/Sprite2D.global_position.x < 1152/2:
				spin_one()
			else:
				spin_two()


func _on_choose_critter_button_choose_critter_button_pressed():
	if spinning:
		return
	var critter = $ChosenText.text.split("\n")[0]
	emit_signal("critter_chosen", critter)
	Global.play_oh_yeah()
