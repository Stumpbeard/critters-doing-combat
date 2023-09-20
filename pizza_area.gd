extends "res://game.gd"


func _on_battle_box_run_away(heat_ratio):
	var tween = create_tween()
	tween.tween_property($BattleBox/Fade, "color:a", 1.0, 0.5)
	tween.tween_callback(emit_signal.bind("battle_over", "pizzeria", heat_ratio))
