extends TextureRect

signal battle_over
signal run_away
signal heal_used
signal killed_boss

@export var player_scene: PackedScene = preload("res://ratler.tscn")
@export var enemy_scene: PackedScene = preload("res://pidge_podge.tscn")
@export var boss_scene: PackedScene = preload("res://roachmeiser.tscn")
@export var final_area = false
var ferroth_scene = preload("res://ferroth.tscn")
var demogator_scene = preload("res://demogator.tscn")

var fading_text_scene = preload("res://fading_text.tscn")
var level_up_scene = preload("res://level_up_pop_up.tscn")
var enemies_killed = {}
var level_info = {"level": 1, "to_next_level": 1, "hp": 0, "strength": 0, "speed": 0, "kill_dollars": 0}
var running_away
var player

var special_attack_readied = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if !final_area:
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(684, 324)
		enemy.is_villain = true
		enemy.add_to_group("enemies")
		add_child(enemy)
		enemy.connect("attacked", _on_attacked)
		enemy.connect("enemy_died", _on_enemy_died)
	if !player:
		player = player_scene.instantiate()
		player.position = Vector2(468, 324)
		player.is_hero = true
		player.connect("attacked", _on_attacked)
		player.connect("hero_died", _on_hero_died)
		add_child(player)

func set_player(player_type):
	player_scene = player_type
	player = player_scene.instantiate()
	player.position = Vector2(468, 324)
	player.is_hero = true
	player.connect("attacked", _on_attacked)
	player.connect("hero_died", _on_hero_died)
	add_child(player)

func _on_enemy_died(critter_type, was_boss=false):
	var enemy_name = ""
	match critter_type:
		0:
			enemy_name = "Ratler"
		1:
			enemy_name = "PidgePodge"
		2:
			enemy_name = "Pizzaling"
		3:
			enemy_name = "Gullmeyer"
		4:
			enemy_name = "Roachmeiser"
		5:
			enemy_name = "Rat-O-Copter"
		6:
			enemy_name = "Baggo"
		7:
			enemy_name = "Mousle"
		8:
			enemy_name = "Coffeeny"
		9:
			enemy_name = "Ferroth"
		10:
			enemy_name = "Demogator"
		11:
			enemy_name = "Securibull"
		12:
			enemy_name = "The CEO"
		13:
			enemy_name = "YHWH"
	if enemy_name in enemies_killed:
		enemies_killed[enemy_name] += 1
	else:
		enemies_killed[enemy_name] = 1
	level_info["kill_dollars"] += 1
	if was_boss:
		level_info["kill_dollars"] += 4
		emit_signal("killed_boss")


func get_live_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var live_enemies = enemies.filter(func(e): return !e.is_dying)
	return live_enemies


func _physics_process(_delta):
	var live_enemies = get_live_enemies()
	if !player.is_dying && !running_away:
		if live_enemies:
			player.is_attacking = true
		else:
			player.is_attacking = false
	if !running_away:
		for enemy in live_enemies:
			if !player.is_dying && !enemy.is_boss_entering:
				enemy.is_attacking = true
			else:
				enemy.is_attacking = false


func _on_attacked(damage, is_villain):
	if !is_villain:
		var enemies = get_live_enemies()
		if enemies:
			var damage_to_send = damage
			var used_special_attack = false
			if special_attack_readied:
				var player_attack_type = $MovesBox.get_selected_move()
				var enemy_resists = enemies[0].get_resistances()
				var fading_text = fading_text_scene.instantiate()
				var damage_mult = 1.25
				fading_text.text = "Nice!"
				for weakness in enemy_resists["weak"]:
					if player_attack_type == weakness:
						damage_mult *= 2.0
				for resistance in enemy_resists["resistant"]:
					if player_attack_type == resistance:
						damage_mult *= 0.5
				damage_to_send *= damage_mult
				damage_to_send = round(damage_to_send)
				if damage_mult >= 2.0:
					fading_text.text = "SUPER!"
				elif damage_mult < 1.0:
					fading_text.text = "Resist..."
				special_attack_readied = false
				used_special_attack = true
				$SpecialMoveButton.trigger_fill()
				
				fading_text.global_position = enemies[0].global_position
				add_child(fading_text)
				player.dismiss_special_attack_glow()
			enemies[0].take_damage(damage_to_send, used_special_attack)
	else:
		player.take_damage(damage)


func _on_heal_button_heal_pressed():
	if !player.is_dying:
		player.heal_up()
		emit_signal("heal_used")


func _on_spawn_system_spawn_enemy():
	if !player.is_dying:
		spawn_enemy()


func spawn_enemy():
	if running_away:
		return
	var enemy = null
	match randi() % 20:
		0:
			enemy = ferroth_scene.instantiate()
		1:
			enemy = demogator_scene.instantiate()
		_:
			enemy = enemy_scene.instantiate()
	enemy.position = Vector2(684, 324)
	enemy.position.x += randi() % 72
	enemy.position.y += randi_range(-144, 72)
	enemy.is_villain = true
	enemy.add_to_group("enemies")
	add_child(enemy)
	enemy.connect("attacked", _on_attacked)
	enemy.connect("enemy_died", _on_enemy_died)
	
func spawn_boss():
	var boss = boss_scene.instantiate()
	boss.is_villain = true
	boss.is_boss = true
	boss.add_to_group("boss")
	boss.add_to_group("enemies")
	boss.connect("attacked", _on_attacked)
	boss.connect("enemy_died", _on_enemy_died)
	boss.position = Vector2(1296, 324)
	add_child(boss)
	create_tween().tween_property(boss, "position:x", 648, 2.0)
	await get_tree().create_timer(3.0).timeout
	boss.is_attacking = true
	boss.is_boss_entering = false


func _on_hero_died():
	if $SpawnSystem:
		$SpawnSystem.stop()
	emit_signal("battle_over")


func _on_run_button_finished_charging():
	if player.is_dying:
		return
	player.flip_h = true
	var tween = create_tween()
	tween.tween_property(player, "position:x", -72.0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_IN
	)
	running_away = true
	for enemy in get_live_enemies():
		enemy.is_attacking = false
	player.is_attacking = false
	emit_signal("run_away", $SpawnSystem.get_heat_ratio())


func set_heat_ratio(ratio):
	$SpawnSystem.set_heat_ratio(ratio)


func set_player_info(new_level_info, heals):
	level_info = new_level_info
	$HealButton.set_heals(heals)
	for level in range(level_info["hp"]):
		player.increase_hp()
	for level in range(level_info["strength"]):
		player.increase_strength()
	for level in range(level_info["speed"]):
		player.increase_speed()
	player.heal_up()


func count_killed_enemies():
	var total = 0
	for enemy in enemies_killed:
		total += enemies_killed[enemy]
	return total


func check_for_level_up():
	if level_info["to_next_level"] <= 1:
#		level_up()
		pass
	else:
		level_info["to_next_level"] -= 1


func do_level_up_math():
	level_info["level"] += 1
	level_info["to_next_level"] = level_info["level"]
	var type_of_level = level_info["level"] % 3
	match type_of_level:
		2:
			player.increase_hp()
			level_info["hp"] += 1
		0:
			player.increase_strength()
			level_info["strength"] += 1
		1:
			player.increase_speed()
			level_info["speed"] += 1


func level_up():
	player.level_up()
	var level_up_pop = level_up_scene.instantiate()
	level_up_pop.position = player.position
	add_child(level_up_pop)
	do_level_up_math()


func _on_special_move_button_moves_pressed():
	special_attack_readied = true
	player.special_attack_glow()

func disable_escape():
	$RunButton.queue_free()
	$NoEscapeLabel.visible = true
