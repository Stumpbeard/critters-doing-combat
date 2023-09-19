extends TextureRect
var pidge_podge_scene = preload("res://pidge_podge.tscn")

var enemies_killed = 0

signal battle_over


# Called when the node enters the scene tree for the first time.
func _ready():
	var pidge_podge = pidge_podge_scene.instantiate()
	pidge_podge.position = Vector2(684, 324)
	pidge_podge.is_villain = true
	pidge_podge.add_to_group("enemies")
	add_child(pidge_podge)
	pidge_podge.connect("attacked", _on_attacked)
	pidge_podge.connect("enemy_died", _on_enemy_died)
	
	
func _on_enemy_died():
	enemies_killed += 1
	
	
func get_live_enemies():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var live_enemies = enemies.filter(func(e): return !e.is_dying)
	return live_enemies
	
func _physics_process(delta):
	var live_enemies = get_live_enemies()
	if !$Ratler.is_dying:
		if live_enemies:
			$Ratler.is_attacking = true
		else:
			$Ratler.is_attacking = false
	for enemy in live_enemies:
		if !$Ratler.is_dying:
			enemy.is_attacking = true
		else:
			enemy.is_attacking = false


func _on_attacked(damage, is_villain):
	if !is_villain:
		var enemies = get_live_enemies()
		if enemies:
			enemies[0].take_damage(damage)
	else:
		$Ratler.take_damage(damage)


func _on_heal_button_heal_pressed():
	if !$Ratler.is_dying:
		$Ratler.current_health = $Ratler.max_health


func _on_spawn_system_spawn_enemy():
	if !$Ratler.is_dying:
		spawn_pidge_podge()


func spawn_pidge_podge():
	var pidge_podge = pidge_podge_scene.instantiate()
	pidge_podge.position = Vector2(684, 324)
	pidge_podge.position.x += randi() % 72
	pidge_podge.position.y += randi_range(-144, 72)
	pidge_podge.is_villain = true
	pidge_podge.add_to_group("enemies")
	add_child(pidge_podge)
	pidge_podge.connect("attacked", _on_attacked)
	pidge_podge.connect("enemy_died", _on_enemy_died)


func _on_chill_button_chill_pressed():
	$SpawnSystem.reduce_heat()


func _on_ratler_hero_died():
	emit_signal("battle_over")
