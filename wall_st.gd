extends "res://game.gd"

var office_img = preload("res://office-bg.png")
var god_img = preload("res://god-bg.png")

var ceo_scene = preload("res://ceo.tscn")
var ceo_song = preload("res://sounds/Jet Fueled Vixen.mp3")
var god_scene = preload("res://god.tscn")
var god_song = preload("res://sounds/OWA.mp3")

var in_lobby = true
var in_office = false
var in_sky = false


func _ready():
	$BattleBox/SpawnSystem.queue_free()
	$BattleBox.disable_escape()
	super._ready()
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(guard_text_one)
	tween.tween_interval(2.0)
	tween.tween_callback(guard_text_two)
	tween.tween_interval(4.0)
	tween.tween_callback(_on_trigger_boss_mode)
	tween.tween_property($GuardText, "modulate:a", 0.0, 1.0)


func _on_battle_box_run_away(heat_ratio):
	var tween = create_tween()
	tween.tween_property($BattleBox/Fade, "color:a", 1.0, 0.5)
	tween.tween_callback(emit_signal.bind("battle_over", "city", heat_ratio))
	

func _on_battle_box_killed_boss():
	if in_sky:
		await get_tree().create_timer(2.0).timeout
		var tween = create_tween()
		tween.tween_property($BattleBox/Fade, "color:a", 1.0, 3.0)
		emit_signal("killed_god")
		_on_battle_box_battle_over()
	else:
		await get_tree().create_timer(2.0).timeout
		close_elevator_doors()


func guard_text_one():
	$GuardText.play_sound = true
	$GuardText.text = "Hey..."
	$GuardText.visible = true
	$GuardText.reset()
	
func guard_text_two():
	$GuardText.text = "You're not\nsupposed to\nbe here!"
	$GuardText.reset()
	
	
func ceo_text_one():
	$CEOText.play_sound = true
	$CEOText.text = "I suppose\nyou want\na meeting..."
	$CEOText.visible = true
	$CEOText.reset()
	
func god_text_one():
	$GodText.play_sound = true
	$GodText.text = "Oh little\none..."
	$GodText.visible = true
	$GodText.reset()
	
func god_text_two():
	$GodText.text = "You know\nnot what\nyou do."
	$GodText.reset()
	
func god_text_three():
	$GodText.text = "Very well."
	$GodText.reset()
	
func god_text_four():
	$GodText.text = "Have at\nyou!"
	$GodText.reset()
	

func rumble_doors():
	var shake_amount = 4
	var tween = create_tween()
	tween.set_loops(15)
	tween.tween_property($Elevator, "position:x", -shake_amount, 0.1)
	tween.tween_property($Elevator, "position:x", shake_amount, 0.1)
	
	
func change_bg():
	if in_lobby:
		$TextureRect.texture = office_img
		in_office = true
		in_lobby = false
		$BattleBox.boss_scene = ceo_scene
		get_node("Music").stream = ceo_song
	elif in_office:
		$TextureRect.texture = god_img
		in_office = false
		in_sky = true
		$BattleBox.boss_scene = god_scene
		get_node("Music").stream = god_song
		

func print_new_text():
	if in_office:
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_callback(ceo_text_one)
		tween.tween_interval(4.0)
		tween.tween_callback(_on_trigger_boss_mode)
		tween.tween_property($CEOText, "modulate:a", 0.0, 1.0)
	elif in_sky:
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_callback(god_text_one)
		tween.tween_interval(2.0)
		tween.tween_callback(god_text_two)
		tween.tween_interval(4.0)
		tween.tween_callback(god_text_three)
		tween.tween_interval(2.0)
		tween.tween_callback(god_text_four)
		tween.tween_interval(2.0)
		tween.tween_callback(_on_trigger_boss_mode)
		tween.tween_property($GodText, "modulate:a", 0.0, 1.0)


func close_elevator_doors():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.2)
	tween.parallel()
	tween.tween_property(self, "position", Vector2(-144, -81), 0.2)
	tween.parallel()
	tween.tween_callback(Global.play_elevator_close)
	tween.tween_property($Elevator/ElevatorDoorLeft, "position:x", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property($Elevator/ElevatorDoorRight, "position:x", 1152/2, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(0.5)
	tween.tween_callback(Global.play_elevator_up)
	tween.tween_callback(rumble_doors)
	tween.tween_callback(change_bg)
	tween.tween_interval(3.5)
	tween.tween_callback(Global.stop_elevator_up)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	tween.parallel()
	tween.tween_property(self, "position", Vector2(0, 0), 0.2)
	tween.parallel()
	tween.tween_callback(Global.play_elevator_close)
	tween.tween_property($Elevator/ElevatorDoorLeft, "position:x", -576, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.parallel()
	tween.tween_property($Elevator/ElevatorDoorRight, "position:x", 1152, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(print_new_text)
	tween.tween_callback(get_node("Music").play)

