extends Sprite2D

signal attacked
signal hero_died
signal enemy_died

enum Critters {RATLER, PIDGE_PODGE, PIZZALING, GULLMEYER}

@export var is_villain = false
@export var is_hero = false
@export var max_health = 10
@export var current_health = 10
@export var attack_speed = 1.0
@export var damage_value = [2, 3]
@export var critter_type: Critters = Critters.RATLER

var exploding_number_scene = preload("res://exploding_number.tscn")

var gravity = 144.0 * 8
var velocity = Vector2()
var is_dying = false
var is_attacking = true


func _ready():
	if is_villain:
		flip_h = true
	$HealthLabel.text = "%s/%s" % [current_health, max_health]
	$AttackTimer.start(attack_speed)


func attack():
	if !is_attacking:
		return
	var tween = create_tween()
	if is_villain:
		tween.tween_property(self, "offset:x", -25, 0.05)
	else:
		tween.tween_property(self, "offset:x", 25, 0.05)
	tween.tween_property(self, "offset:x", 0, 0.05)
	emit_signal("attacked", randi_range(damage_value[0], damage_value[1]), is_villain)
	
func take_damage(dam):
	current_health = max(0, current_health - dam)
	$HealthLabel.text = "%s/%s" % [current_health, max_health]
	var exploding_number = exploding_number_scene.instantiate()
	exploding_number.number = dam
	add_child(exploding_number)
	exploding_number.global_position = $HealthLabel.global_position
	if current_health == 0:
		die()

func _physics_process(delta):
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
				emit_signal("enemy_died", critter_type)
				queue_free()
			elif is_hero:
				gravity = 0
				velocity = Vector2()
				emit_signal("hero_died")

func die():
	velocity.x = randf() * 288.0 - 144.0
	velocity.y = gravity * -(randf() * 0.75 + 1.0)
	is_dying = true
	$AttackTimer.stop()
	$HealthLabel.visible = false


func _on_attack_timer_timeout():
	attack()
