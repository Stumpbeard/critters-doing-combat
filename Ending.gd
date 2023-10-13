extends TextureRect

@export var critter_graphic: Texture2D = preload("res://ratler.png")
var pidge_graphic = preload("res://pidgepodge.png")
var coffee_graphic = preload("res://coffeeny.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.play_waves()
	create_tween().tween_property($WhiteFade, "color:a", 0, 4.0)
	$SailingCritter.texture = critter_graphic
	var waves_tween = create_tween()
	waves_tween.tween_interval(2.0)
	waves_tween.tween_callback($Music.play)
	var tween = create_tween()
	tween.set_loops()
	tween.tween_callback(bob_up)
	tween.tween_interval(2.0)
	tween.tween_callback(bob_down)
	tween.tween_interval(2.0)
	
	var tween_text = create_tween()
	tween_text.tween_interval(6.0)
	tween_text.tween_callback(print_text_one)
	
func set_critter_graphic(critter):
	if critter == "PidgePodge":
		critter_graphic = pidge_graphic
	elif critter == "Coffeeny":
		critter_graphic = coffee_graphic

func bob_up():
	create_tween().tween_property($SailingCritter, "position", $SailingCritter.position + Vector2(16, -16), 2.0)

func bob_down():
	create_tween().tween_property($SailingCritter, "position", $SailingCritter.position + Vector2(16, 16), 2.0)

func print_text_one():
	$TypingText.play_sound = true
	$TypingText.text = "And so..."
	$TypingText.reset()
	var tween = create_tween()
	tween.tween_interval(4.0)
	tween.tween_callback(print_text_two)
	
func print_text_two():
	$TypingText.text = "And so...\nAfter killing God..."
	$TypingText.reset()
	$TypingText.visible_characters = len("And so...\n")
	var tween = create_tween()
	tween.tween_interval(4.0)
	tween.tween_callback(print_text_three)
	
func print_text_three():
	$TypingText.text = "And so...\nAfter killing God...\nThe critter sailed away from NYC.\n\n"
	$TypingText.reset()
	$TypingText.visible_characters = len("And so...\nAfter killing God...\n")
	var tween = create_tween()
	tween.tween_interval(4.0)
	tween.tween_callback(print_text_four)
	
func print_text_four():
	$TypingText.text = "And so...\nAfter killing God...\nThe critter sailed away from NYC.\n\nIs this the end of their story..?"
	$TypingText.reset()
	$TypingText.visible_characters = len("And so...\nAfter killing God...\nThe critter sailed away from NYC.\n\n")
	var tween = create_tween()
	tween.tween_interval(8.0)
	tween.tween_callback(print_text_five)

func print_text_five():
	$TypingText.text = "And so...\nAfter killing God...\nThe critter sailed away from NYC.\n\nIs this the end of their story..?\n\n\nYeah, probably."
	$TypingText.reset()
	$TypingText.visible_characters = len("And so...\nAfter killing God...\nThe critter sailed away from NYC.\n\nIs this the end of their story..?\n\n\n")
	var tween = create_tween()
	tween.tween_interval(4.0)
	tween.tween_property($TypingText, "modulate:a", 0.0, 4.0)
	tween.tween_callback($Credits.start)
