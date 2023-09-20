extends Node2D

signal battle_over


func _on_battle_box_battle_over():
	$GameOver/GameOverLabel.text = "You killed:"
	for enemy in $BattleBox.enemies_killed:
		$GameOver/GameOverLabel.text += "\n\t%s %s" % [$BattleBox.enemies_killed[enemy], enemy]
	$GameOver.visible = true


func _on_battle_box_run_away(heat_ratio):
	var tween = create_tween()
	tween.tween_property($BattleBox/Fade, "color:a", 1.0, 0.5)
	tween.tween_callback(emit_signal.bind("battle_over"))

func get_enemies_killed():
	return $BattleBox.enemies_killed
	
func set_enemies_killed(kills):
	$BattleBox.enemies_killed = kills

func set_heat_ratio(ratio):
	$BattleBox.set_heat_ratio(ratio)
