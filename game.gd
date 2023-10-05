extends Node2D

signal battle_over
signal killed_god

@export var song = preload("res://sounds/Salty Ditty.mp3")


func _ready():
	$BattleBox/SpawnSystem.connect("trigger_boss_mode", _on_trigger_boss_mode)
	var music = AudioStreamPlayer.new()
	music.stream = song
	music.name = "Music"
	music.bus = "Music"
	add_child(music)
	play_music()
	

func play_music():
	get_node("Music").play()
	
	
func _on_trigger_boss_mode():
	Global.play_danger()
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.die(true)
		
	var warning_red_tween = create_tween()
	warning_red_tween.tween_property($WarningRect, "color:a", 0.5, 0.5)
	warning_red_tween.tween_property($WarningRect, "color:a", 0.0, 0.5)
	warning_red_tween.tween_property($WarningRect, "color:a", 0.5, 0.5)
	warning_red_tween.tween_property($WarningRect, "color:a", 0.0, 0.5)
	warning_red_tween.tween_property($WarningRect, "color:a", 0.5, 0.5)
	warning_red_tween.tween_property($WarningRect, "color:a", 0.0, 0.5)
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2, 2), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(self, "position", Vector2(-1152/2.0, -648/2.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(self, "position", Vector2(0, 0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(self, "position", Vector2((1152*1.5 - 1152)/-2.0, (648*1.5 - 648)/-2.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(self, "position", Vector2(0, 0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(self, "position", Vector2((1152*1.2 - 1152)/-2.0, (648*1.2 - 648)/-2.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property(self, "position", Vector2(0, 0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	var top_warning_tween = create_tween()
	top_warning_tween.tween_property($TopScrollingWarningLabel, "modulate:a", 1.0, 0.3)
	top_warning_tween.tween_interval(2.7)
	top_warning_tween.tween_property($TopScrollingWarningLabel, "modulate:a", 0.0, 0.2)
	$TopScrollingWarningLabel.play()
	
	var bottom_warning_tween = create_tween()
	bottom_warning_tween.tween_property($BottomScrollingWarningLabel, "modulate:a", 1.0, 0.3)
	bottom_warning_tween.tween_interval(2.7)
	bottom_warning_tween.tween_property($BottomScrollingWarningLabel, "modulate:a", 0.0, 0.2)
	$BottomScrollingWarningLabel.play(true)
	
	$BattleBox.spawn_boss()


func _on_battle_box_battle_over():
	$GameOver/GameOverLabel.text = "You killed:"
	for enemy in $BattleBox.enemies_killed:
		$GameOver/GameOverLabel.text += "\n\t%s %s" % [$BattleBox.enemies_killed[enemy], enemy]
	$GameOver/GameOverLabel.text += "\n\nYou were level %s" % [$BattleBox.level_info["level"]]
	$GameOver.visible = true


func _on_battle_box_run_away(heat_ratio):
	var tween = create_tween()
	tween.tween_property($BattleBox/Fade, "color:a", 1.0, 0.5)
	tween.tween_callback(emit_signal.bind("battle_over", heat_ratio))


func get_enemies_killed():
	return $BattleBox.enemies_killed


func get_level_info():
	return $BattleBox.level_info


func set_enemies_killed(kills):
	$BattleBox.enemies_killed = kills


func set_heat_ratio(ratio):
	$BattleBox.set_heat_ratio(ratio)


func set_player_info(level_info, heals):
	$BattleBox.set_player_info(level_info, heals)


func _on_battle_box_killed_boss():
	var tween = create_tween()
	tween.tween_property($VictoryBanner, "modulate:a", 1.0, 0.2)
	tween.parallel()
	tween.tween_property($VictoryBanner, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_interval(1.0)
	tween.tween_property($BattleBox/Fade, "color:a", 1.0, 0.5)
	await get_tree().create_timer(2.0).timeout
