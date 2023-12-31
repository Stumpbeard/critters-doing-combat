class_name Critter
extends Sprite2D

signal attacked
signal hero_died
signal enemy_died

enum Critters { RATLER, PIDGE_PODGE, PIZZALING, GULLMEYER, ROACHMEISER, RATOCOPTER, BAGGO, MOUSLE, COFFEENY, FERROTH, DEMOGATOR, SECURIBULL, CEO, GOD }
enum Types { RODENT, TRASH, BIRD, HOLY, DEVIL, NORMAL }

@export var is_villain = false
@export var is_hero = false
@export var is_boss = false
@export var max_health = 10
@export var current_health = 10
@export var attack_speed = 1.0
@export var damage_value = [2, 3]
@export var critter_type: Critters = Critters.RATLER
@export var status_types: Array[Types] = [Types.RODENT]
@export var in_shop_mode = false

var exploding_number_scene = preload("res://exploding_number.tscn")

var gravity = 144.0 * 8
var velocity = Vector2()
var is_dying = false
var is_attacking = true
var is_leveling = false
var is_glowing = false
var is_boss_entering = false


func _ready():
	if is_villain:
		flip_h = true
	if is_boss:
		is_boss_entering = true
		$HoverActivation.scale *= 2
		$HoverActivation.position.y -= 32
	$HealthLabel.text = "%s/%s" % [current_health, max_health]
	$AttackTimer.start(attack_speed)
	duplicate_tex_but_yellow()
	if in_shop_mode:
		$HealthLabel.visible = false
		scale = Vector2(2, 2)
		$AttackTimer.stop()
		jump()
	set_hover_info()
	
func set_hover_info():
	match critter_type:
		Critters.RATLER:
			$HoverInfo/Name.text = "Ratler"
		Critters.PIDGE_PODGE:
			$HoverInfo/Name.text = "PidgePodge"
		Critters.COFFEENY:
			$HoverInfo/Name.text = "Coffeeny"
		Critters.PIZZALING:
			$HoverInfo/Name.text = "Pizzaling"
		Critters.GULLMEYER:
			$HoverInfo/Name.text = "Gullmeyer"
		Critters.MOUSLE:
			$HoverInfo/Name.text = "Mousle"
		Critters.ROACHMEISER:
			$HoverInfo/Name.text = "Roachmeiser"
		Critters.RATOCOPTER:
			$HoverInfo/Name.text = "Rat-O-Copter"
		Critters.BAGGO:
			$HoverInfo/Name.text = "Baggo"
		Critters.FERROTH:
			$HoverInfo/Name.text = "Ferroth"
		Critters.DEMOGATOR:
			$HoverInfo/Name.text = "Demogator"
		Critters.SECURIBULL:
			$HoverInfo/Name.text = "Securibull"
		Critters.CEO:
			$HoverInfo/Name.text = "The CEO"
		Critters.GOD:
			$HoverInfo/Name.text = "YHWH"
	var first_type = status_types[0]
	match first_type:
		Types.RODENT:
			$HoverInfo/Type.text = "Rodent"
		Types.BIRD:
			$HoverInfo/Type.text = "Bird"
		Types.TRASH:
			$HoverInfo/Type.text = "Trash"
		Types.HOLY:
			$HoverInfo/Type.text = "Holy"
		Types.DEVIL:
			$HoverInfo/Type.text = "Devil"
	for type in status_types.slice(1):
		match type:
			Types.RODENT:
				$HoverInfo/Type.text += "/Rodent"
			Types.BIRD:
				$HoverInfo/Type.text += "/Bird"
			Types.TRASH:
				$HoverInfo/Type.text += "/Trash"
			Types.HOLY:
				$HoverInfo/Type.text += "/Holy"
			Types.DEVIL:
				$HoverInfo/Type.text += "/Devil"
		
func jump():
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 16, 0.1)
	tween.tween_property(self, "position:y", position.y, 0.1)
	tween.tween_interval(0.5)
	tween.tween_callback(jump)

	var other_tween = create_tween()
	var roll = randi() % 2
	if roll == 0 && position.x < 1076+48:
		other_tween.tween_property(
			self, "position:x", position.x + 16, 0.2
		)
		flip_h = false
	else:
		other_tween.tween_property(
			self, "position:x", position.x - 16, 0.2
		)
		self.flip_h = true


func attack():
	if !is_attacking:
		return false
	var tween = create_tween()
	if is_villain:
		tween.tween_property(self, "offset:x", -25, min(0.05, attack_speed))
	else:
		tween.tween_property(self, "offset:x", 25, min(0.05, attack_speed))
	tween.tween_property(self, "offset:x", 0, min(0.05, attack_speed))
	emit_signal("attacked", randi_range(damage_value[0], damage_value[1]), is_villain)
	Global.play_critter_attack(critter_type)
	return true


func take_damage(dam, special_used = false):
	current_health = max(0, current_health - dam)
	$HealthLabel.text = "%s/%s" % [current_health, max_health]
	var exploding_number = exploding_number_scene.instantiate()
	exploding_number.number = dam
	if special_used:
		do_extra_wiggle()
	add_child(exploding_number)
	exploding_number.global_position = $HealthLabel.global_position
	if current_health == 0:
		die()

func do_extra_wiggle():
	var tween = create_tween()
	tween.tween_property(self, "offset:x", offset.x + 4, 0.05)
	tween.tween_property(self, "offset:x", offset.x - 8, 0.05)
	tween.tween_property(self, "offset:x", offset.x + 6, 0.05)
	tween.tween_property(self, "offset:x", offset.x - 4, 0.05)
	tween.tween_property(self, "offset:x", offset.x + 2, 0.05)

func _physics_process(delta):
	var yellow = get_node("YellowLayer")
	var blue = get_node("BlueLayer")
	if yellow:
		yellow.offset = offset
	if blue:
		blue.offset = offset
	if in_shop_mode:
		return
	$HealthLabel.text = "%s/%s" % [current_health, max_health]
	if is_dying:
		is_attacking = false
		var movement = Vector2()
		velocity.y = min(0, velocity.y + gravity * delta)
		movement.x = velocity.x
		movement.y += velocity.y
		movement.y += gravity

		position += movement * delta
		if position.y > 2000:
			if is_villain:
				queue_free()
			elif is_hero:
				gravity = 0
				velocity = Vector2()
				emit_signal("hero_died")


func die(skip_credit=false):
	Global.play_pow()
	velocity.x = randf() * 288.0 - 144.0
	velocity.y = gravity * -(randf() * 0.75 + 1.0)
	is_dying = true
	$AttackTimer.stop()
	$HealthLabel.visible = false
	if is_villain:
		if !skip_credit:
			emit_signal("enemy_died", critter_type, is_boss)


func _on_attack_timer_timeout():
	attack()


func duplicate_tex_but_yellow():
	var new_img: Image = texture.get_image()
	var blu_img: Image = texture.get_image()
	for y in new_img.get_height():
		for x in new_img.get_width():
			if new_img.get_pixel(x, y).a == 1.0:
				new_img.set_pixel(x, y, Color(251.0 / 255.0, 242.0 / 255.0, 54.0 / 255.0, 1.0))
				blu_img.set_pixel(x, y, Color(95.0 / 255.0, 205.0 / 255.0, 228.0 / 255.0, 1.0))
	var new_tex = Sprite2D.new()
	new_tex.texture = ImageTexture.create_from_image(new_img)
	new_tex.name = "YellowLayer"
	new_tex.modulate.a = 0.0
	new_tex.flip_h = flip_h
	
	var special_tex = Sprite2D.new()
	special_tex.texture = ImageTexture.create_from_image(blu_img)
	special_tex.name = "BlueLayer"
	special_tex.show_behind_parent = true
	special_tex.flip_h = flip_h
	special_tex.visible = false
	
	add_child(new_tex)
	add_child(special_tex)


func level_up():
	scale = Vector2(1, 1)
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 2, 0.2)
	tween.tween_property(self, "scale", scale, 0.2)
	rotation_degrees = 0
	var rot_tween = create_tween()
	rot_tween.tween_property(self, "rotation_degrees", 720, 0.4)
	rot_tween.tween_callback(set_rotation_degrees.bind(0))
	get_node("YellowLayer").modulate.a = 0.0
	var yellow_tween = create_tween()
	yellow_tween.tween_property(get_node("YellowLayer"), "modulate:a", 1.0, 0.2)
	yellow_tween.tween_property(get_node("YellowLayer"), "modulate:a", 0.0, 0.2)


func increase_hp():
	max_health += 1


func increase_strength():
	damage_value[1] += 1
	if damage_value[1] % 6 == 0:
		damage_value[0] += 1


func increase_speed():
	attack_speed = max(0.1, attack_speed - 0.02)


func heal_up():
	current_health = max_health


func special_attack_glow():
	get_node("BlueLayer").visible = true
	is_glowing = true
	var blue_glow = get_node("BlueLayer")
	var tween = create_tween()
	tween.tween_property(blue_glow, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property(blue_glow, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_callback(loop_special_attack_glow)
	
	
func loop_special_attack_glow():
	if is_glowing:
		var blue_glow = get_node("BlueLayer")
		var tween = create_tween()
		tween.tween_property(blue_glow, "scale", Vector2(1.2, 1.2), 0.2)
		tween.tween_property(blue_glow, "scale", Vector2(1.1, 1.1), 0.2)
		tween.tween_callback(loop_special_attack_glow)
	
func dismiss_special_attack_glow():
	get_node("BlueLayer").visible = false
	is_glowing = false
	var blue_glow = get_node("BlueLayer")
	create_tween().tween_property(blue_glow, "scale", Vector2(1.0, 1.0), 0.1)
	
func get_resistances():
	var resists = {
		"weak": [],
		"resistant": []
	}
	# Weaknesses pass
	for type in status_types:
		match type:
			Types.RODENT:
				resists["weak"].append(Types.BIRD)
			Types.BIRD:
				resists["weak"].append(Types.TRASH)
			Types.TRASH:
				resists["weak"].append(Types.RODENT)
			Types.HOLY:
				resists["weak"].append(Types.DEVIL)
			Types.DEVIL:
				resists["weak"].append(Types.HOLY)
	# Resistance overwrite
	for type in status_types:
		match type:
			Types.RODENT:
				if Types.TRASH in resists["weak"]:
					resists["weak"].erase(Types.TRASH)
				else:
					resists['resistant'].append(Types.TRASH)
			Types.BIRD:
				if Types.RODENT in resists["weak"]:
					resists["weak"].erase(Types.RODENT)
				else:
					resists['resistant'].append(Types.RODENT)
			Types.TRASH:
				if Types.BIRD in resists["weak"]:
					resists["weak"].erase(Types.BIRD)
				else:
					resists['resistant'].append(Types.BIRD)
			Types.HOLY:
				if Types.RODENT in resists["weak"]:
					resists["weak"].erase(Types.RODENT)
				else:
					resists['resistant'].append(Types.RODENT)
				if Types.BIRD in resists["weak"]:
					resists["weak"].erase(Types.BIRD)
				else:
					resists['resistant'].append(Types.BIRD)
				if Types.TRASH in resists["weak"]:
					resists["weak"].erase(Types.TRASH)
				else:
					resists['resistant'].append(Types.TRASH)
	return resists


func _on_hover_activation_mouse_entered():
	if in_shop_mode:
		return
	$HoverInfo.visible = true
	$HoverInfo.global_position = get_viewport().get_mouse_position()


func _on_hover_activation_mouse_exited():
	if in_shop_mode:
		return
	$HoverInfo.visible = false


func _on_hover_activation_input_event(viewport, event, shape_idx):
	if in_shop_mode:
		return
	if event is InputEventMouseMotion:
		$HoverInfo.global_position = get_viewport().get_mouse_position()
