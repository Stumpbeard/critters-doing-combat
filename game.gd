extends Node2D

signal battle_over


func _on_battle_box_battle_over():
	$GameOver/GameOverLabel.text = "You killed:"
	for enemy in $BattleBox.enemies_killed:
		$GameOver/GameOverLabel.text += "\n\t%s %s" % [$BattleBox.enemies_killed[enemy], enemy]
	$GameOver/GameOverLabel.text += "\n\nYou were level %s" % [$BattleBox.level_info["level"]]
	$GameOver.visible = true


func _on_battle_box_run_away(heat_ratio):
	var tween = create_tween()
	tween.tween_property($BattleBox/Fade, "color:a", 1.0, 0.5)
	tween.tween_callback(emit_signal.bind("battle_over"))

func get_enemies_killed():
	return $BattleBox.enemies_killed
	
func get_level_info():
	return $BattleBox.level_info
	
func set_enemies_killed(kills):
	$BattleBox.enemies_killed = kills

func set_heat_ratio(ratio):
	$BattleBox.set_heat_ratio(ratio)

func set_level_info(level_info):
	$BattleBox.set_level_info(level_info)
